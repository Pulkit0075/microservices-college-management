package com.college.student.repository;

import com.college.student.entity.Student;
import com.college.student.entity.StudentStatus;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

/**
 * Repository interface for Student entity operations
 */
@Repository
public interface StudentRepository extends JpaRepository<Student, Long> {

    /**
     * Find student by student ID
     */
    Optional<Student> findByStudentId(String studentId);

    /**
     * Find student by email
     */
    Optional<Student> findByEmail(String email);

    /**
     * Check if student exists by student ID
     */
    boolean existsByStudentId(String studentId);

    /**
     * Check if student exists by email
     */
    boolean existsByEmail(String email);

    /**
     * Find students by department
     */
    List<Student> findByDepartment(String department);

    /**
     * Find students by status
     */
    List<Student> findByStatus(StudentStatus status);

    /**
     * Find students by department and status
     */
    List<Student> findByDepartmentAndStatus(String department, StudentStatus status);

    /**
     * Find students by year of study
     */
    List<Student> findByYearOfStudy(Integer yearOfStudy);

    /**
     * Search students by name (first name or last name)
     */
    @Query("SELECT s FROM Student s WHERE " +
           "LOWER(s.firstName) LIKE LOWER(CONCAT('%', :name, '%')) OR " +
           "LOWER(s.lastName) LIKE LOWER(CONCAT('%', :name, '%'))")
    List<Student> findByNameContaining(@Param("name") String name);

    /**
     * Find students with pagination
     */
    Page<Student> findByStatus(StudentStatus status, Pageable pageable);

    /**
     * Find students by department with pagination
     */
    Page<Student> findByDepartment(String department, Pageable pageable);

    /**
     * Count students by status
     */
    long countByStatus(StudentStatus status);

    /**
     * Count students by department
     */
    long countByDepartment(String department);

    /**
     * Find all departments
     */
    @Query("SELECT DISTINCT s.department FROM Student s WHERE s.department IS NOT NULL ORDER BY s.department")
    List<String> findAllDepartments();
}