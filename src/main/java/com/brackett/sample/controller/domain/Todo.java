package com.brackett.sample.controller.domain;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.uuid.Generators;
import org.springframework.data.annotation.Id;
import org.springframework.data.annotation.PersistenceCreator;
import org.springframework.data.annotation.Transient;
import org.springframework.data.domain.Persistable;

import java.io.Serializable;
import java.util.UUID;

public record Todo(
        @Id UUID id,
        String message,
        Boolean completed,
        @Transient @JsonIgnore Boolean newOne) implements Serializable,
        Persistable<UUID> {

    public Todo {
        if (id == null) {
            id = Generators.timeBasedEpochGenerator().generate();
            newOne = true;
        }
        else {
            newOne = false;
        }
        if (completed == null) {
            completed = false;
        }
    }

    @PersistenceCreator
    public Todo(UUID id, String message, Boolean completed) {
        this(id, message, completed, false);
    }

    @Override
    public UUID getId() {
        return id;
    }

    @Override
    @JsonIgnore
    public boolean isNew() {
        return newOne;
    }
}
