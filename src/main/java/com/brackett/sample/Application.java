package com.brackett.sample;

import io.swagger.v3.oas.annotations.OpenAPIDefinition;
import io.swagger.v3.oas.annotations.info.Info;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.context.properties.ConfigurationPropertiesScan;

@SpringBootApplication
@ConfigurationPropertiesScan({ "com.brackett.sample.config" })
@OpenAPIDefinition(info = @Info(title = "Sample Service", description = "Josh Brackett Sample service", version = "1"))
public class Application {

    public static void main(String[] args) {
        SpringApplication.run(Application.class, args);
    }
}