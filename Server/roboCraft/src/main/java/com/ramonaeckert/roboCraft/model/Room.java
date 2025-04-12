package com.ramonaeckert.roboCraft.model;

import java.time.Instant;
import java.util.List;
import java.util.concurrent.CopyOnWriteArrayList;

public class Room {
    private String code;
    private String owner;
    private List<Participant> participants;
    private Instant lastOpened;

    private List<Exercise> exercises;


    public Room(String code, String owner) {
        this.code = code;
        this.owner = owner;
        this.participants = new CopyOnWriteArrayList<>();
        this.lastOpened = Instant.now();
    }

    public String getCode() {
        return code;
    }

    public String getOwner() {
        return owner;
    }

    public List<Participant> getParticipants() {
        return participants;
    }
    public void setParticipant(List<Participant> participants) {
        this.participants = participants;
    }

    public void addParticipant(Participant participant) {
        this.participants.add(participant);
    }

    public Instant getLastOpened() {
        return lastOpened;
    }

    public void updateLastOpened() {
        this.lastOpened = Instant.now();
    }

    public List<Exercise> getExercises() {
        return exercises;
    }

    public void addNewExercise(String exerciseId) {
        for (Exercise exercise : exercises) {
            exercise.setStatus("past");
        }

        exercises.add(new Exercise(exerciseId, "current"));
    }
}
