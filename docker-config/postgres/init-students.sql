-- Student Database Schema
-- This script initializes the student database with required tables

-- Create students table
CREATE TABLE IF NOT EXISTS students (
    id BIGSERIAL PRIMARY KEY,
    student_id VARCHAR(20) UNIQUE NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    phone VARCHAR(20),
    date_of_birth DATE,
    admission_date DATE,
    status VARCHAR(20) DEFAULT 'ACTIVE',
    department_id BIGINT,
    address TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create admissions table
CREATE TABLE IF NOT EXISTS admissions (
    id BIGSERIAL PRIMARY KEY,
    application_id VARCHAR(20) UNIQUE NOT NULL,
    student_id BIGINT REFERENCES students(id),
    course VARCHAR(100) NOT NULL,
    admission_status VARCHAR(20) DEFAULT 'PENDING',
    application_date DATE,
    decision_date DATE,
    entrance_score DECIMAL(5,2),
    documents_verified BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create departments table
CREATE TABLE IF NOT EXISTS departments (
    id BIGSERIAL PRIMARY KEY,
    dept_code VARCHAR(10) UNIQUE NOT NULL,
    dept_name VARCHAR(100) NOT NULL,
    head_of_department VARCHAR(100),
    established_year INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create academic_records table
CREATE TABLE IF NOT EXISTS academic_records (
    id BIGSERIAL PRIMARY KEY,
    student_id BIGINT REFERENCES students(id),
    semester INTEGER NOT NULL,
    year INTEGER NOT NULL,
    gpa DECIMAL(3,2),
    total_credits INTEGER,
    status VARCHAR(20) DEFAULT 'IN_PROGRESS',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Add foreign key constraint for students.department_id
ALTER TABLE students ADD CONSTRAINT fk_student_department 
    FOREIGN KEY (department_id) REFERENCES departments(id);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_students_email ON students(email);
CREATE INDEX IF NOT EXISTS idx_students_student_id ON students(student_id);
CREATE INDEX IF NOT EXISTS idx_admissions_application_id ON admissions(application_id);
CREATE INDEX IF NOT EXISTS idx_admissions_status ON admissions(admission_status);
CREATE INDEX IF NOT EXISTS idx_academic_records_student_id ON academic_records(student_id);

-- Insert sample departments
INSERT INTO departments (dept_code, dept_name, head_of_department, established_year) VALUES
('CSE', 'Computer Science and Engineering', 'Dr. John Smith', 1995),
('ECE', 'Electronics and Communication Engineering', 'Dr. Sarah Johnson', 1990),
('ME', 'Mechanical Engineering', 'Dr. Michael Brown', 1985),
('CE', 'Civil Engineering', 'Dr. Emily Davis', 1980),
('IT', 'Information Technology', 'Dr. David Wilson', 2000)
ON CONFLICT (dept_code) DO NOTHING;

-- Insert sample students
INSERT INTO students (student_id, first_name, last_name, email, phone, date_of_birth, admission_date, department_id, address) VALUES
('STU001', 'Alice', 'Johnson', 'alice.johnson@college.edu', '+1234567890', '2000-05-15', '2022-08-01', 1, '123 Main St, City, State'),
('STU002', 'Bob', 'Smith', 'bob.smith@college.edu', '+1234567891', '1999-12-20', '2022-08-01', 1, '456 Oak Ave, City, State'),
('STU003', 'Carol', 'Brown', 'carol.brown@college.edu', '+1234567892', '2001-03-10', '2022-08-01', 2, '789 Pine Rd, City, State'),
('STU004', 'David', 'Wilson', 'david.wilson@college.edu', '+1234567893', '2000-08-25', '2022-08-01', 3, '321 Elm St, City, State'),
('STU005', 'Emma', 'Davis', 'emma.davis@college.edu', '+1234567894', '2001-01-30', '2023-08-01', 4, '654 Cedar Ave, City, State')
ON CONFLICT (student_id) DO NOTHING;

-- Insert sample admissions
INSERT INTO admissions (application_id, student_id, course, admission_status, application_date, decision_date, entrance_score, documents_verified) VALUES
('APP001', 1, 'B.Tech Computer Science', 'APPROVED', '2022-06-01', '2022-07-15', 85.50, TRUE),
('APP002', 2, 'B.Tech Computer Science', 'APPROVED', '2022-06-02', '2022-07-15', 82.75, TRUE),
('APP003', 3, 'B.Tech Electronics', 'APPROVED', '2022-06-03', '2022-07-15', 88.25, TRUE),
('APP004', 4, 'B.Tech Mechanical', 'APPROVED', '2022-06-04', '2022-07-15', 79.50, TRUE),
('APP005', 5, 'B.Tech Civil', 'APPROVED', '2023-06-01', '2023-07-15', 86.75, TRUE)
ON CONFLICT (application_id) DO NOTHING;

-- Insert sample academic records
INSERT INTO academic_records (student_id, semester, year, gpa, total_credits, status) VALUES
(1, 1, 2022, 8.5, 20, 'COMPLETED'),
(1, 2, 2023, 8.2, 22, 'COMPLETED'),
(2, 1, 2022, 7.8, 20, 'COMPLETED'),
(2, 2, 2023, 8.0, 22, 'COMPLETED'),
(3, 1, 2022, 9.0, 20, 'COMPLETED'),
(3, 2, 2023, 8.8, 22, 'COMPLETED'),
(4, 1, 2022, 7.5, 20, 'COMPLETED'),
(4, 2, 2023, 7.7, 22, 'COMPLETED'),
(5, 1, 2023, 8.3, 20, 'COMPLETED')
ON CONFLICT DO NOTHING;

-- Create a function to update the updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Create triggers to automatically update the updated_at timestamp
CREATE TRIGGER update_students_updated_at BEFORE UPDATE ON students
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_admissions_updated_at BEFORE UPDATE ON admissions
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_academic_records_updated_at BEFORE UPDATE ON academic_records
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Grant necessary permissions
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO student_user;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO student_user;