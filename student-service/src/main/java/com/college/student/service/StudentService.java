package com.college.student.service;

import com.college.student.dto.StudentDto;
import com.college.student.entity.StudentStatus;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import java.util.List;
import java.util.Optional;

/**
 * Service interface for Student operations
 */
public interface StudentService {

    /**
     * Create a new student
     */
    StudentDto createStudent(StudentDto studentDto);

    /**
     * Update an existing student
     */
    StudentDto updateStudent(Long id, StudentDto studentDto);

    /**
     * Get student by ID
     */
    Optional<StudentDto> getStudentById(Long id);

    /**
     * Get student by student ID
     */
    Optional<StudentDto> getStudentByStudentId(String studentId);

    /**
     * Get all students with pagination
     */
    Page<StudentDto> getAllStudents(Pageable pageable);

    /**
     * Get students by department
     */
    List<StudentDto> getStudentsByDepartment(String department);

    /**
     * Get students by status
     */
    List<StudentDto> getStudentsByStatus(StudentStatus status);

    /**
     * Search students by name
     */
    List<StudentDto> searchStudentsByName(String name);

    /**
     * Delete student by ID
     */
    boolean deleteStudent(Long id);

    /**
     * Update student status
     */
    StudentDto updateStudentStatus(Long id, StudentStatus status);

    /**
     * Get all departments
     */
    List<String> getAllDepartments();

    /**
     * Get student count by status
     */
    long getStudentCountByStatus(StudentStatus status);

    /**
     * Check if student exists by student ID
     */
    boolean existsByStudentId(String studentId);

    /**
     * Check if student exists by email
     */
    boolean existsByEmail(String email);
}