package com.college.student.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.sql.DataSource;
import java.sql.Connection;
import java.util.HashMap;
import java.util.Map;

/**
 * Health check controller for monitoring service health
 */
@RestController
@RequestMapping("/api/v1/health")
public class HealthController {

    @Autowired
    private DataSource dataSource;

    /**
     * Basic health check
     */
    @GetMapping
    public ResponseEntity<Map<String, Object>> health() {
        Map<String, Object> health = new HashMap<>();
        health.put("status", "UP");
        health.put("service", "student-service");
        health.put("timestamp", System.currentTimeMillis());
        
        return ResponseEntity.ok(health);
    }

    /**
     * Detailed health check including database connectivity
     */
    @GetMapping("/detailed")
    public ResponseEntity<Map<String, Object>> detailedHealth() {
        Map<String, Object> health = new HashMap<>();
        Map<String, Object> database = new HashMap<>();
        
        try (Connection connection = dataSource.getConnection()) {
            database.put("status", "UP");
            database.put("database", connection.getMetaData().getDatabaseProductName());
            database.put("url", connection.getMetaData().getURL());
        } catch (Exception e) {
            database.put("status", "DOWN");
            database.put("error", e.getMessage());
        }
        
        health.put("status", "UP");
        health.put("service", "student-service");
        health.put("database", database);
        health.put("timestamp", System.currentTimeMillis());
        
        return ResponseEntity.ok(health);
    }
}