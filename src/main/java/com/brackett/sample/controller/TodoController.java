package com.brackett.sample.controller;

import com.brackett.sample.controller.domain.Todo;
import com.brackett.sample.exceptions.InvalidTodoException;
import com.brackett.sample.repository.TodoRepository;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@RestController
@RequestMapping("todos")
public class TodoController {

    private final TodoRepository todoRepository;

    public TodoController(TodoRepository todoRepository) {
        this.todoRepository = todoRepository;
    }

    @GetMapping
    public List<Todo> getTodos(@RequestParam Optional<Boolean> completed) {
        return todoRepository.findByCompleted(completed.orElse(false));
    }

    @GetMapping("{id}")
    public Todo getTodoById(@PathVariable UUID id) {
        return todoRepository.findById(id).orElse(null);
    }

    @PostMapping
    public Todo saveTodo(@RequestBody Todo todo) {
        return todoRepository.save(todo);
    }

    @PutMapping("{id}")
    public Todo updateTodoById(@PathVariable UUID id, @RequestBody Todo todo) {
        if (!id.equals(todo.id())) {
            throw new InvalidTodoException("ID mismatch");
        }
        return todoRepository.save(todo);
    }

    @DeleteMapping("{id}")
    public void deleteTodoById(@PathVariable UUID id) {
        todoRepository.deleteById(id);
    }

}
