package com.college.student.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonBackReference;
import org.hibernate.annotations.CreationTimestamp;

import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * Admission entity representing student admission records
 */
@Entity
@Table(name = "admissions")
public class Admission {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "student_id", nullable = false)
    @JsonBackReference
    private Student student;

    @Column(name = "admission_year", nullable = false)
    @NotNull(message = "Admission year is required")
    private Integer admissionYear;

    @Column(name = "program", nullable = false, length = 100)
    @NotBlank(message = "Program is required")
    private String program;

    @Column(name = "admission_date")
    @JsonFormat(pattern = "yyyy-MM-dd")
    private LocalDate admissionDate;

    @Enumerated(EnumType.STRING)
    @Column(name = "admission_status")
    private AdmissionStatus admissionStatus = AdmissionStatus.PENDING;

    @Column(name = "entrance_score")
    private Double entranceScore;

    @Column(name = "remarks", columnDefinition = "TEXT")
    private String remarks;

    @CreationTimestamp
    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;

    // Default constructor
    public Admission() {}

    // Constructor with required fields
    public Admission(Student student, Integer admissionYear, String program) {
        this.student = student;
        this.admissionYear = admissionYear;
        this.program = program;
        this.admissionDate = LocalDate.now();
    }

    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Student getStudent() { return student; }
    public void setStudent(Student student) { this.student = student; }

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

    @Override
    public String toString() {
        return "Admission{" +
                "id=" + id +
                ", admissionYear=" + admissionYear +
                ", program='" + program + '\'' +
                ", admissionStatus=" + admissionStatus +
                '}';
    }
}