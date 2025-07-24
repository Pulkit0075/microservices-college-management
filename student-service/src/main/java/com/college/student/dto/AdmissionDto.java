package com.college.student.dto;

import com.college.student.entity.AdmissionStatus;
import com.fasterxml.jackson.annotation.JsonFormat;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * Data Transfer Object for Admission
 */
public class AdmissionDto {

    private Long id;
    private Long studentId;

    @NotNull(message = "Admission year is required")
    private Integer admissionYear;

    @NotBlank(message = "Program is required")
    private String program;

    @JsonFormat(pattern = "yyyy-MM-dd")
    private LocalDate admissionDate;

    private AdmissionStatus admissionStatus;
    private Double entranceScore;
    private String remarks;

    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime createdAt;

    // Default constructor
    public AdmissionDto() {}

    // Constructor with required fields
    public AdmissionDto(Long studentId, Integer admissionYear, String program) {
        this.studentId = studentId;
        this.admissionYear = admissionYear;
        this.program = program;
        this.admissionDate = LocalDate.now();
        this.admissionStatus = AdmissionStatus.PENDING;
    }

    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Long getStudentId() { return studentId; }
    public void setStudentId(Long studentId) { this.studentId = studentId; }

    public Integer getAdmissionYear() { return admissionYear; }
    public void setAdmissionYear(Integer admissionYear) { this.admissionYear = admissionYear; }

    public String getProgram() { return program; }
    public void setProgram(String program) { this.program = program; }

    public LocalDate getAdmissionDate() { return admissionDate; }
    public void setAdmissionDate(LocalDate admissionDate) { this.admissionDate = admissionDate; }

    public AdmissionStatus getAdmissionStatus() { return admissionStatus; }
    public void setAdmissionStatus(AdmissionStatus admissionStatus) { this.admissionStatus = admissionStatus; }

    public Double getEntranceScore() { return entranceScore; }
    public void setEntranceScore(Double entranceScore) { this.entranceScore = entranceScore; }

    public String getRemarks() { return remarks; }
    public void setRemarks(String remarks) { this.remarks = remarks; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}