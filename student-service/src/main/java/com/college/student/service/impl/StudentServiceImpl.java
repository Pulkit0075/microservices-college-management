package com.college.student.service.impl;

import com.college.student.dto.StudentDto;
import com.college.student.entity.Student;
import com.college.student.entity.StudentStatus;
import com.college.student.repository.StudentRepository;
import com.college.student.service.StudentService;
import com.college.student.util.StudentMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

/**
 * Implementation of StudentService
 */
@Service
@Transactional
public class StudentServiceImpl implements StudentService {

    private static final Logger logger = LoggerFactory.getLogger(StudentServiceImpl.class);

    @Autowired
    private StudentRepository studentRepository;

    @Autowired
    private StudentMapper studentMapper;

    @Override
    public StudentDto createStudent(StudentDto studentDto) {
        logger.info("Creating new student with ID: {}", studentDto.getStudentId());

        // Check if student already exists
        if (studentRepository.existsByStudentId(studentDto.getStudentId())) {
            throw new IllegalArgumentException("Student with ID " + studentDto.getStudentId() + " already exists");
        }

        if (studentRepository.existsByEmail(studentDto.getEmail())) {
            throw new IllegalArgumentException("Student with email " + studentDto.getEmail() + " already exists");
        }

        Student student = studentMapper.toEntity(studentDto);
        student.setStatus(StudentStatus.ACTIVE);
        
        Student savedStudent = studentRepository.save(student);
        logger.info("Successfully created student with ID: {}", savedStudent.getStudentId());
        
        return studentMapper.toDto(savedStudent);
    }

    @Override
    public StudentDto updateStudent(Long id, StudentDto studentDto) {
        logger.info("Updating student with ID: {}", id);

        Student existingStudent = studentRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Student not found with ID: " + id));

        // Check if email is being changed and if the new email already exists
        if (!existingStudent.getEmail().equals(studentDto.getEmail()) &&
                studentRepository.existsByEmail(studentDto.getEmail())) {
            throw new IllegalArgumentException("Student with email " + studentDto.getEmail() + " already exists");
        }

        // Update fields
        existingStudent.setFirstName(studentDto.getFirstName());
        existingStudent.setLastName(studentDto.getLastName());
        existingStudent.setEmail(studentDto.getEmail());
        existingStudent.setPhone(studentDto.getPhone());
        existingStudent.setDateOfBirth(studentDto.getDateOfBirth());
        existingStudent.setAddress(studentDto.getAddress());
        existingStudent.setDepartment(studentDto.getDepartment());
        existingStudent.setYearOfStudy(studentDto.getYearOfStudy());

        Student savedStudent = studentRepository.save(existingStudent);
        logger.info("Successfully updated student with ID: {}", id);
        
        return studentMapper.toDto(savedStudent);
    }

    @Override
    @Transactional(readOnly = true)
    public Optional<StudentDto> getStudentById(Long id) {
        logger.debug("Fetching student with ID: {}", id);
        return studentRepository.findById(id)
                .map(studentMapper::toDto);
    }

    @Override
    @Transactional(readOnly = true)
    public Optional<StudentDto> getStudentByStudentId(String studentId) {
        logger.debug("Fetching student with student ID: {}", studentId);
        return studentRepository.findByStudentId(studentId)
                .map(studentMapper::toDto);
    }

    @Override
    @Transactional(readOnly = true)
    public Page<StudentDto> getAllStudents(Pageable pageable) {
        logger.debug("Fetching all students with pagination");
        return studentRepository.findAll(pageable)
                .map(studentMapper::toDto);
    }

    @Override
    @Transactional(readOnly = true)
    public List<StudentDto> getStudentsByDepartment(String department) {
        logger.debug("Fetching students by department: {}", department);
        return studentRepository.findByDepartment(department)
                .stream()
                .map(studentMapper::toDto)
                .collect(Collectors.toList());
    }

    @Override
    @Transactional(readOnly = true)
    public List<StudentDto> getStudentsByStatus(StudentStatus status) {
        logger.debug("Fetching students by status: {}", status);
        return studentRepository.findByStatus(status)
                .stream()
                .map(studentMapper::toDto)
                .collect(Collectors.toList());
    }

    @Override
    @Transactional(readOnly = true)
    public List<StudentDto> searchStudentsByName(String name) {
        logger.debug("Searching students by name: {}", name);
        return studentRepository.findByNameContaining(name)
                .stream()
                .map(studentMapper::toDto)
                .collect(Collectors.toList());
    }

    @Override
    public boolean deleteStudent(Long id) {
        logger.info("Deleting student with ID: {}", id);
        
        if (!studentRepository.existsById(id)) {
            logger.warn("Student not found with ID: {}", id);
            return false;
        }

        studentRepository.deleteById(id);
        logger.info("Successfully deleted student with ID: {}", id);
        return true;
    }

    @Override
    public StudentDto updateStudentStatus(Long id, StudentStatus status) {
        logger.info("Updating student status to {} for ID: {}", status, id);

        Student student = studentRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Student not found with ID: " + id));

        student.setStatus(status);
        Student savedStudent = studentRepository.save(student);
        
        logger.info("Successfully updated student status for ID: {}", id);
        return studentMapper.toDto(savedStudent);
    }

    @Override
    @Transactional(readOnly = true)
    public List<String> getAllDepartments() {
        logger.debug("Fetching all departments");
        return studentRepository.findAllDepartments();
    }

    @Override
    @Transactional(readOnly = true)
    public long getStudentCountByStatus(StudentStatus status) {
        logger.debug("Getting student count by status: {}", status);
        return studentRepository.countByStatus(status);
    }

    @Override
    @Transactional(readOnly = true)
    public boolean existsByStudentId(String studentId) {
        return studentRepository.existsByStudentId(studentId);
    }

    @Override
    @Transactional(readOnly = true)
    public boolean existsByEmail(String email) {
        return studentRepository.existsByEmail(email);
    }
}