package com.ramonaeckert.roboCraft.model;

import java.time.Instant;
import java.util.HashMap;
import java.util.Map;

public class Participant {
    private String id;
    private String name;
    private int score;

    private Boolean isActive;

    private Boolean isReady;

    private Map<String, Instant> completedExercises;

    public Participant(String name, String userId) {
        this.name = name;
        this.score = 0;
        this.id = userId;
        this.isActive = true;
        this.isReady = true;
        completedExercises = new HashMap<String, Instant>();
    }

    public Map<String, Instant> getCompletedExercises() {
        return completedExercises;
    }

    public Boolean addCompletedExercise(String exerciseId) {
        if (this.didCompleteExercise(exerciseId)) {
            return false;
        }

        this.completedExercises.put(exerciseId, Instant.now());
        return true;
    }

    public Boolean didCompleteExercise(String exerciseId) {
        return this.completedExercises.containsKey(exerciseId);
    }

    public String getName() {
        return name;
    }

    public int getScore() {
        return score;
    }

    public void setName(String name) {
        this.name = name;
    }

    public void setScore(int score) {
        this.score = score;
    }

    public String getId() {
        return id;
    }

    public Boolean getIsActive() {
        return isActive;
    }

    public void setIsActive(Boolean isActive) {
        this.isActive = isActive;
    }

    public Boolean getIsReady() {
        return isReady;
    }

    public void setIsReady(Boolean isReady) {
        this.isReady = isReady;
    }
}
