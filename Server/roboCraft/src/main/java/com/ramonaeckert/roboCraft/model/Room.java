package com.ramonaeckert.roboCraft.model;

import java.util.List;
import java.util.concurrent.CopyOnWriteArrayList;

public class Room {
    private String code;
    private String owner;
    private List<Participant> participants;

public Room(String code, String owner) {
        this.code = code;
        this.owner = owner;
        this.participants = new CopyOnWriteArrayList<>();
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
}
