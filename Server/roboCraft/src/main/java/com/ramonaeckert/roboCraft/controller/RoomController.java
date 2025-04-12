package com.ramonaeckert.roboCraft.controller;

import com.ramonaeckert.roboCraft.model.Exercise;
import com.ramonaeckert.roboCraft.model.Participant;
import com.ramonaeckert.roboCraft.model.Room;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.web.bind.annotation.*;

import java.time.Instant;
import java.util.*;
import java.util.concurrent.ConcurrentHashMap;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/rooms")
public class RoomController {
    private final Map<String, Room> rooms = new ConcurrentHashMap<>();
    private final SimpMessagingTemplate messagingTemplate;

    public RoomController(SimpMessagingTemplate messagingTemplate) {
        this.messagingTemplate = messagingTemplate;
    }
    @PostMapping("/create")
    public ResponseEntity<Map<String, Object>> createRoom(@RequestBody Map<String, String> requestBody) {
        String owner = requestBody.get("owner");

        // Check if the owner already has too rooms
        List<Room> existingRoom = rooms.values().stream()
                .filter(room -> room.getOwner().equals(owner)).toList();

        //Each owner can only have 10 rooms at once
        if (existingRoom.size() >= 10) {
            // Return the existing room
            System.out.println("Owner: " + owner + "already has 10 rooms");
            return ResponseEntity.badRequest().body(Map.of("message", "You cannot create more than 10 rooms"));
        }

        // Create new room
        String uniqueCode = UUID.randomUUID().toString().substring(0, 4);
        Room room = new Room(uniqueCode, owner);
        rooms.put(uniqueCode, room);

        // Response
        System.out.println("Created Room for " + owner);
        return ResponseEntity.ok(Map.of(
                "code", room.getCode(),
                "isOwner", true,
                "participants", room.getParticipants()
        ));
    }

    @GetMapping("/owned-rooms/{userId}")
    public ResponseEntity<List<Map<String, Object>>> getOwnedRooms(@PathVariable String userId) {
        // Get all rooms owned by the user by checking the owner field
        List<Map<String, Object>> ownedRooms = rooms.values().stream()
                .filter(room -> room.getOwner().equals(userId))  // Filter by owner
                .map(room -> Map.of(
                        "code", room.getCode(),
                        "isOwner", true,
                        "participants", room.getParticipants()
                ))
                .collect(Collectors.toList());  // Collect results into a list

        // Return the list of rooms as a JSON response
        return ResponseEntity.ok(ownedRooms);
    }

    @DeleteMapping("/delete/{roomCode}")
    public ResponseEntity<Boolean> deleteRoom(@RequestBody Map<String, String> requestBody, @PathVariable String roomCode) {
        String userId = requestBody.get("userId");

        // Find the room with the provided roomCode
        Room room = rooms.get(roomCode);

        // Check if the room exists
        if (room == null) {
            return ResponseEntity.status(404).body(false);
        }

        // Check if the user is the owner of the room
        if (!room.getOwner().equals(userId)) {
            return ResponseEntity.status(403).body(false);
        }

        // Delete the room
        rooms.remove(roomCode);

        // Return a success message
        return ResponseEntity.ok(true);
    }

    @GetMapping("/{code}")
    public ResponseEntity<Boolean> roomExists(@PathVariable String code) {
        return ResponseEntity.ok(rooms.containsKey(code));
    }

    @GetMapping("/{code}/past-exercises")
    public ResponseEntity<List<Exercise>> getPastExercises(@PathVariable String code) {
        Room room = rooms.get(code);
        if (room == null) {
            return ResponseEntity.badRequest().body(new ArrayList<Exercise>());
        }

        // Return the list of exercises directly
        return ResponseEntity.ok(room.getExercises());
    }

    @PostMapping("/{code}/join")
    public ResponseEntity<Map<String, Object>> joinRoom(@PathVariable String code, @RequestBody Map<String, String> requestBody) {
        String userName = requestBody.get("userName");
        String userId = requestBody.get("userId");

        Room room = rooms.get(code);
        if (room == null) {
            return ResponseEntity.badRequest().body(Map.of("message", "Room not found"));
        }

        if (room.getOwner().equals(userId)) {
            room.updateLastOpened();

            return ResponseEntity.ok(Map.of(
                    "code", room.getCode(),
                    "isOwner", true,
                    "participants", room.getParticipants()
            ));
        }

        // Check if the participant with the same userId already exists
        boolean userExists = room.getParticipants().stream()
                .anyMatch(participant -> participant.getId().equals(userId));

        if (!userExists) {
            Participant newParticipant = new Participant(userName, userId);
            room.addParticipant(newParticipant);
        } else {
            room.getParticipants().stream()
                    .filter(participant -> participant.getId().equals(userId))
                    .findFirst()
                    .ifPresent(participant -> {
                        participant.setName(userName);
                        participant.setIsActive(true);
                    });
        }

        // Send message to all subscribed clients in this room
        messagingTemplate.convertAndSend("/topic/room/" + code,
                Map.of(
                        "participants", room.getParticipants()
                ));

        return ResponseEntity.ok(Map.of(
                "code", room.getCode(),
                "isOwner", false,
                "participants", room.getParticipants()
        ));
    }

    @PostMapping("/{code}/leave")
    public ResponseEntity<Boolean> leaveRoom(@PathVariable String code, @RequestBody Map<String, String> requestBody) {
        String userId = requestBody.get("userId");

        Room room = rooms.get(code);
        if (room == null) {
            return ResponseEntity.badRequest().body(false);
        }

        boolean userFound = room.getParticipants().stream()
                .anyMatch(participant -> participant.getId().equals(userId));

        if (!userFound) {
            return ResponseEntity.badRequest().body(false);
        }

        room.getParticipants().forEach(participant -> {
            if (participant.getId().equals(userId)) {
                participant.setIsActive(false);
            }
        });

        // Send updated ParticipantList to all subscribed clients in this room
        messagingTemplate.convertAndSend("/topic/room/" + code,
                Map.of(
                        "participants", room.getParticipants()
                ));

        return ResponseEntity.ok(true);
    }

    @PostMapping("/{code}/exercise")
    public ResponseEntity<Boolean> sendExercise(@PathVariable String code, @RequestBody Map<String, String> requestBody) {
        String userId = requestBody.get("userId");
        String exerciseData = requestBody.get("exercise");
        String exerciseId = requestBody.get("exerciseId");

        Room room = rooms.get(code);
        if (room == null) {
            return ResponseEntity.badRequest().body(false);
        } else if (!room.getOwner().equals(userId)) {
            return ResponseEntity.badRequest().body(false);
        } else if (exerciseId == null) {
            return ResponseEntity.badRequest().body(false);
        }

        // Send exercise to all subscribed clients in this room
        messagingTemplate.convertAndSend("/topic/exercise/" + code, exerciseData);
        room.addNewExercise(exerciseId);

        return ResponseEntity.ok(true);
    }

    @Scheduled(cron = "0 0 3 * * ?") // every day at 3 AM
    public void cleanUpOldRooms() {
        Instant oneWeekAgo = Instant.now().minusSeconds(7 * 24 * 60 * 60); // 7 days in seconds

        rooms.entrySet().removeIf(entry -> {
            Room room = entry.getValue();
            boolean isOld = room.getLastOpened().isBefore(oneWeekAgo);
            if (isOld) {
                System.out.println("Deleting old room: " + room.getCode());
            }
            return isOld;
        });
    }
}
