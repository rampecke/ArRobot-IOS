package com.ramonaeckert.roboCraft.model;

import java.util.UUID;

public class Participant {
    private String id;
    private String name;
    private int score;

    private Boolean isActive;

    public Participant(String name, String userId) {
        this.name = name;
        this.score = 0;
        this.id = userId;
        this.isActive = true;
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
}
