package com.college.student;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.transaction.annotation.EnableTransactionManagement;

/**
 * Main application class for Student Service
 * 
 * This is the entry point for the Student microservice.
 * It handles student admissions, enrollment, and management.
 */
@SpringBootApplication
@EnableTransactionManagement
public class StudentServiceApplication {

    public static void main(String[] args) {
        SpringApplication.run(StudentServiceApplication.class, args);
    }
}