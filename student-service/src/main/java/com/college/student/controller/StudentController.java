package com.college.student.controller;

import com.college.student.dto.StudentDto;
import com.college.student.entity.StudentStatus;
import com.college.student.service.StudentService;
import jakarta.validation.Valid;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;
import java.util.Optional;

/**
 * REST Controller for Student operations
 */
@RestController
@RequestMapping("/api/v1/students")
@CrossOrigin(origins = "*")
public class StudentController {

    private static final Logger logger = LoggerFactory.getLogger(StudentController.class);

    @Autowired
    private StudentService studentService;

    /**
     * Create a new student
     */
    @PostMapping
    public ResponseEntity<StudentDto> createStudent(@Valid @RequestBody StudentDto studentDto) {
        logger.info("Received request to create student with ID: {}", studentDto.getStudentId());
        
        try {
            StudentDto createdStudent = studentService.createStudent(studentDto);
            return new ResponseEntity<>(createdStudent, HttpStatus.CREATED);
        } catch (IllegalArgumentException e) {
            logger.error("Error creating student: {}", e.getMessage());
            return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
        }
    }

    /**
     * Get all students with pagination
     */
    @GetMapping
    public ResponseEntity<Page<StudentDto>> getAllStudents(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(defaultValue = "id") String sortBy,
            @RequestParam(defaultValue = "asc") String sortDir) {
        
        logger.debug("Fetching students - page: {}, size: {}, sortBy: {}, sortDir: {}", 
                    page, size, sortBy, sortDir);

        Sort sort = sortDir.equalsIgnoreCase("desc") ? 
                   Sort.by(sortBy).descending() : Sort.by(sortBy).ascending();
        
        Pageable pageable = PageRequest.of(page, size, sort);
        Page<StudentDto> students = studentService.getAllStudents(pageable);
        
        return ResponseEntity.ok(students);
    }

    /**
     * Get student by ID
     */
    @GetMapping("/{id}")
    public ResponseEntity<StudentDto> getStudentById(@PathVariable Long id) {
        logger.debug("Fetching student with ID: {}", id);
        
        Optional<StudentDto> student = studentService.getStudentById(id);
        return student.map(s -> ResponseEntity.ok(s))
                     .orElse(ResponseEntity.notFound().build());
    }

    /**
     * Get student by student ID
     */
    @GetMapping("/student-id/{studentId}")
    public ResponseEntity<StudentDto> getStudentByStudentId(@PathVariable String studentId) {
        logger.debug("Fetching student with student ID: {}", studentId);
        
        Optional<StudentDto> student = studentService.getStudentByStudentId(studentId);
        return student.map(s -> ResponseEntity.ok(s))
                     .orElse(ResponseEntity.notFound().build());
    }

    /**
     * Update student
     */
    @PutMapping("/{id}")
    public ResponseEntity<StudentDto> updateStudent(
            @PathVariable Long id, 
            @Valid @RequestBody StudentDto studentDto) {
        
        logger.info("Received request to update student with ID: {}", id);
        
        try {
            StudentDto updatedStudent = studentService.updateStudent(id, studentDto);
            return ResponseEntity.ok(updatedStudent);
        } catch (IllegalArgumentException e) {
            logger.error("Error updating student: {}", e.getMessage());
            return ResponseEntity.notFound().build();
        }
    }

    /**
     * Delete student
     */
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteStudent(@PathVariable Long id) {
        logger.info("Received request to delete student with ID: {}", id);
        
        boolean deleted = studentService.deleteStudent(id);
        return deleted ? ResponseEntity.noContent().build() : ResponseEntity.notFound().build();
    }

    /**
     * Update student status
     */
    @PatchMapping("/{id}/status")
    public ResponseEntity<StudentDto> updateStudentStatus(
            @PathVariable Long id, 
            @RequestBody Map<String, String> statusUpdate) {
        
        logger.info("Received request to update status for student ID: {}", id);
        
        try {
            String statusStr = statusUpdate.get("status");
            StudentStatus status = StudentStatus.valueOf(statusStr.toUpperCase());
            
            StudentDto updatedStudent = studentService.updateStudentStatus(id, status);
            return ResponseEntity.ok(updatedStudent);
        } catch (IllegalArgumentException e) {
            logger.error("Error updating student status: {}", e.getMessage());
            return ResponseEntity.badRequest().build();
        }
    }

    /**
     * Get students by department
     */
    @GetMapping("/department/{department}")
    public ResponseEntity<List<StudentDto>> getStudentsByDepartment(@PathVariable String department) {
        logger.debug("Fetching students by department: {}", department);
        
        List<StudentDto> students = studentService.getStudentsByDepartment(department);
        return ResponseEntity.ok(students);
    }

    /**
     * Get students by status
     */
    @GetMapping("/status/{status}")
    public ResponseEntity<List<StudentDto>> getStudentsByStatus(@PathVariable String status) {
        logger.debug("Fetching students by status: {}", status);
        
        try {
            StudentStatus studentStatus = StudentStatus.valueOf(status.toUpperCase());
            List<StudentDto> students = studentService.getStudentsByStatus(studentStatus);
            return ResponseEntity.ok(students);
        } catch (IllegalArgumentException e) {
            logger.error("Invalid status: {}", status);
            return ResponseEntity.badRequest().build();
        }
    }

    /**
     * Search students by name
     */
    @GetMapping("/search")
    public ResponseEntity<List<StudentDto>> searchStudents(@RequestParam String name) {
        logger.debug("Searching students by name: {}", name);
        
        List<StudentDto> students = studentService.searchStudentsByName(name);
        return ResponseEntity.ok(students);
    }

    /**
     * Get all departments
     */
    @GetMapping("/departments")
    public ResponseEntity<List<String>> getAllDepartments() {
        logger.debug("Fetching all departments");
        
        List<String> departments = studentService.getAllDepartments();
        return ResponseEntity.ok(departments);
    }

    /**
     * Get student statistics
     */
    @GetMapping("/statistics")
    public ResponseEntity<Map<String, Object>> getStatistics() {
        logger.debug("Fetching student statistics");
        
        Map<String, Object> stats = Map.of(
            "totalActive", studentService.getStudentCountByStatus(StudentStatus.ACTIVE),
            "totalInactive", studentService.getStudentCountByStatus(StudentStatus.INACTIVE),
            "totalGraduated", studentService.getStudentCountByStatus(StudentStatus.GRADUATED),
            "totalSuspended", studentService.getStudentCountByStatus(StudentStatus.SUSPENDED),
            "totalDroppedOut", studentService.getStudentCountByStatus(StudentStatus.DROPPED_OUT)
        );
        
        return ResponseEntity.ok(stats);
    }

    /**
     * Check if student exists by student ID
     */
    @GetMapping("/exists/student-id/{studentId}")
    public ResponseEntity<Map<String, Boolean>> checkStudentIdExists(@PathVariable String studentId) {
        boolean exists = studentService.existsByStudentId(studentId);
        return ResponseEntity.ok(Map.of("exists", exists));
    }

    /**
     * Check if student exists by email
     */
    @GetMapping("/exists/email/{email}")
    public ResponseEntity<Map<String, Boolean>> checkEmailExists(@PathVariable String email) {
        boolean exists = studentService.existsByEmail(email);
        return ResponseEntity.ok(Map.of("exists", exists));
    }
}