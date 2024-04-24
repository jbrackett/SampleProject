package com.brackett.sample.repository;

import com.brackett.sample.controller.domain.Todo;
import org.springframework.data.repository.CrudRepository;

import java.util.List;
import java.util.UUID;

public interface TodoRepository extends CrudRepository<Todo, UUID>{

    List<Todo> findByCompleted(boolean completed);
}
