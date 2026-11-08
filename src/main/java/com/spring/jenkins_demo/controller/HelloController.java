package com.spring.jenkins_demo.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

@RestController
public class HelloController {
    @GetMapping("/")
    public Map<String, String> home() {
        return Map.of(
                "message", "Hello! Jenkins deployment successful.",
                "application", "Jenkins Maven Demo",
                "status", "RUNNING"
        );
    }

    @GetMapping("/health")
    public Map<String, String> health() {
        return Map.of("status", "UP");
    }
}
