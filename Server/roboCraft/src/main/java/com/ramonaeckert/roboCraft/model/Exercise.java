package com.ramonaeckert.roboCraft.model;

public class Exercise {
    private String id;
    private String status;

    public Exercise(String id, String status) {
        this.id = id;
        this.status = status;
    }

    public String getId() {
        return id;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}
