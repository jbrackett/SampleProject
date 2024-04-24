package com.brackett.sample.repository;

import com.brackett.sample.controller.domain.Todo;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import static org.junit.jupiter.api.Assertions.assertNotNull;

@SpringBootTest
public class TodoRepositoryTest {

    @Autowired
    private TodoRepository todoRepository;

    @Test
    public void testSaveTodo() {
        var todo = new Todo(null, "test", false, false);
        var result = todoRepository.save(todo);
        assertNotNull(result);
    }
}
