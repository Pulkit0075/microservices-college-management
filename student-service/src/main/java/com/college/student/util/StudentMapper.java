package com.college.student.util;

import com.college.student.dto.AdmissionDto;
import com.college.student.dto.StudentDto;
import com.college.student.entity.Admission;
import com.college.student.entity.Student;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.stream.Collectors;

/**
 * Mapper utility for converting between entities and DTOs
 */
@Component
public class StudentMapper {

    /**
     * Convert Student entity to StudentDto
     */
    public StudentDto toDto(Student student) {
        if (student == null) {
            return null;
        }

        StudentDto dto = new StudentDto();
        dto.setId(student.getId());
        dto.setStudentId(student.getStudentId());
        dto.setFirstName(student.getFirstName());
        dto.setLastName(student.getLastName());
        dto.setEmail(student.getEmail());
        dto.setPhone(student.getPhone());
        dto.setDateOfBirth(student.getDateOfBirth());
        dto.setAddress(student.getAddress());
        dto.setDepartment(student.getDepartment());
        dto.setYearOfStudy(student.getYearOfStudy());
        dto.setStatus(student.getStatus());
        dto.setCreatedAt(student.getCreatedAt());
        dto.setUpdatedAt(student.getUpdatedAt());

        if (student.getAdmissions() != null) {
            List<AdmissionDto> admissionDtos = student.getAdmissions()
                    .stream()
                    .map(this::toAdmissionDto)
                    .collect(Collectors.toList());
            dto.setAdmissions(admissionDtos);
        }

        return dto;
    }

    /**
     * Convert StudentDto to Student entity
     */
    public Student toEntity(StudentDto dto) {
        if (dto == null) {
            return null;
        }

        Student student = new Student();
        student.setId(dto.getId());
        student.setStudentId(dto.getStudentId());
        student.setFirstName(dto.getFirstName());
        student.setLastName(dto.getLastName());
        student.setEmail(dto.getEmail());
        student.setPhone(dto.getPhone());
        student.setDateOfBirth(dto.getDateOfBirth());
        student.setAddress(dto.getAddress());
        student.setDepartment(dto.getDepartment());
        student.setYearOfStudy(dto.getYearOfStudy());
        student.setStatus(dto.getStatus());

        return student;
    }

    /**
     * Convert Admission entity to AdmissionDto
     */
    public AdmissionDto toAdmissionDto(Admission admission) {
        if (admission == null) {
            return null;
        }

        AdmissionDto dto = new AdmissionDto();
        dto.setId(admission.getId());
        dto.setStudentId(admission.getStudent().getId());
        dto.setAdmissionYear(admission.getAdmissionYear());
        dto.setProgram(admission.getProgram());
        dto.setAdmissionDate(admission.getAdmissionDate());
        dto.setAdmissionStatus(admission.getAdmissionStatus());
        dto.setEntranceScore(admission.getEntranceScore());
        dto.setRemarks(admission.getRemarks());
        dto.setCreatedAt(admission.getCreatedAt());

        return dto;
    }

    /**
     * Convert AdmissionDto to Admission entity
     */
    public Admission toAdmissionEntity(AdmissionDto dto) {
        if (dto == null) {
            return null;
        }

        Admission admission = new Admission();
        admission.setId(dto.getId());
        admission.setAdmissionYear(dto.getAdmissionYear());
        admission.setProgram(dto.getProgram());
        admission.setAdmissionDate(dto.getAdmissionDate());
        admission.setAdmissionStatus(dto.getAdmissionStatus());
        admission.setEntranceScore(dto.getEntranceScore());
        admission.setRemarks(dto.getRemarks());

        return admission;
    }
}