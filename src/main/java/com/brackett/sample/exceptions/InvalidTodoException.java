package com.brackett.sample.exceptions;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ResponseStatus;

@ResponseStatus(value = HttpStatus.BAD_REQUEST)
public class InvalidTodoException extends RuntimeException{

    public InvalidTodoException(String message) {
        super(message);
    }

    public InvalidTodoException(String message, Exception e) {
        super(message, e);
    }
}
