package com.college.student.repository;

import com.college.student.entity.Admission;
import com.college.student.entity.AdmissionStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * Repository interface for Admission entity operations
 */
@Repository
public interface AdmissionRepository extends JpaRepository<Admission, Long> {

    /**
     * Find admissions by student ID
     */
    List<Admission> findByStudentId(Long studentId);

    /**
     * Find admissions by student student ID
     */
    @Query("SELECT a FROM Admission a WHERE a.student.studentId = :studentId")
    List<Admission> findByStudentStudentId(@Param("studentId") String studentId);

    /**
     * Find admissions by status
     */
    List<Admission> findByAdmissionStatus(AdmissionStatus status);

    /**
     * Find admissions by year
     */
    List<Admission> findByAdmissionYear(Integer year);

    /**
     * Find admissions by program
     */
    List<Admission> findByProgram(String program);

    /**
     * Count admissions by status
     */
    long countByAdmissionStatus(AdmissionStatus status);

    /**
     * Count admissions by year
     */
    long countByAdmissionYear(Integer year);

    /**
     * Find all programs
     */
    @Query("SELECT DISTINCT a.program FROM Admission a ORDER BY a.program")
    List<String> findAllPrograms();
}