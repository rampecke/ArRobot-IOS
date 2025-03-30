package com.ramonaeckert.roboCraft.controller;

import com.ramonaeckert.roboCraft.model.Participant;
import com.ramonaeckert.roboCraft.model.Room;
import org.springframework.http.ResponseEntity;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.web.bind.annotation.*;

import java.util.Map;
import java.util.Optional;
import java.util.UUID;
import java.util.concurrent.ConcurrentHashMap;

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

        // Check if the owner already has a room
        Optional<Room> existingRoom = rooms.values().stream()
                .filter(room -> room.getOwner().equals(owner))
                .findFirst();

        if (existingRoom.isPresent()) {
            // Return the existing room
            System.out.println("Room already exists for " + owner + ". Returning existing room.");
            Room room = existingRoom.get();
            return ResponseEntity.ok(Map.of(
                    "code", room.getCode(),
                    "isOwner", true,
                    "participants", room.getParticipants()
            ));
        }

        // Create new room
        String uniqueCode = UUID.randomUUID().toString().substring(0, 8);
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

    @GetMapping("/{code}")
    public ResponseEntity<Boolean> roomExists(@PathVariable String code) {
        return ResponseEntity.ok(rooms.containsKey(code));
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
            return ResponseEntity.badRequest().body(Map.of("message", "You cannot join your own room"));
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
                    .ifPresent(participant -> participant.setName(userName));
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
}
