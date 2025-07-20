-- Faculty Database Schema
-- This script initializes the faculty database with required tables

-- Create faculty table
CREATE TABLE IF NOT EXISTS faculty (
    id BIGSERIAL PRIMARY KEY,
    employee_id VARCHAR(20) UNIQUE NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    phone VARCHAR(20),
    department VARCHAR(100),
    designation VARCHAR(100),
    hire_date DATE,
    salary DECIMAL(10,2),
    status VARCHAR(20) DEFAULT 'ACTIVE',
    address TEXT,
    qualification VARCHAR(200),
    experience_years INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create courses table
CREATE TABLE IF NOT EXISTS courses (
    id BIGSERIAL PRIMARY KEY,
    course_code VARCHAR(20) UNIQUE NOT NULL,
    course_name VARCHAR(200) NOT NULL,
    faculty_id BIGINT REFERENCES faculty(id),
    credits INTEGER,
    department VARCHAR(100),
    semester INTEGER,
    year INTEGER,
    max_students INTEGER DEFAULT 60,
    description TEXT,
    prerequisites TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create faculty_courses table (many-to-many relationship)
CREATE TABLE IF NOT EXISTS faculty_courses (
    id BIGSERIAL PRIMARY KEY,
    faculty_id BIGINT REFERENCES faculty(id),
    course_id BIGINT REFERENCES courses(id),
    academic_year INTEGER,
    semester INTEGER,
    role VARCHAR(50) DEFAULT 'INSTRUCTOR', -- INSTRUCTOR, COORDINATOR, ASSISTANT
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(faculty_id, course_id, academic_year, semester)
);

-- Create schedules table
CREATE TABLE IF NOT EXISTS schedules (
    id BIGSERIAL PRIMARY KEY,
    faculty_id BIGINT REFERENCES faculty(id),
    course_id BIGINT REFERENCES courses(id),
    day_of_week VARCHAR(10) NOT NULL, -- MONDAY, TUESDAY, etc.
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    room_number VARCHAR(20),
    academic_year INTEGER,
    semester INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create research_projects table
CREATE TABLE IF NOT EXISTS research_projects (
    id BIGSERIAL PRIMARY KEY,
    project_title VARCHAR(300) NOT NULL,
    principal_investigator BIGINT REFERENCES faculty(id),
    funding_amount DECIMAL(12,2),
    start_date DATE,
    end_date DATE,
    status VARCHAR(20) DEFAULT 'ACTIVE',
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create performance_reviews table
CREATE TABLE IF NOT EXISTS performance_reviews (
    id BIGSERIAL PRIMARY KEY,
    faculty_id BIGINT REFERENCES faculty(id),
    review_period VARCHAR(20), -- 2023-2024, etc.
    teaching_rating DECIMAL(3,2),
    research_rating DECIMAL(3,2),
    service_rating DECIMAL(3,2),
    overall_rating DECIMAL(3,2),
    comments TEXT,
    reviewer_name VARCHAR(100),
    review_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_faculty_email ON faculty(email);
CREATE INDEX IF NOT EXISTS idx_faculty_employee_id ON faculty(employee_id);
CREATE INDEX IF NOT EXISTS idx_faculty_department ON faculty(department);
CREATE INDEX IF NOT EXISTS idx_courses_code ON courses(course_code);
CREATE INDEX IF NOT EXISTS idx_courses_department ON courses(department);
CREATE INDEX IF NOT EXISTS idx_faculty_courses_faculty ON faculty_courses(faculty_id);
CREATE INDEX IF NOT EXISTS idx_faculty_courses_course ON faculty_courses(course_id);
CREATE INDEX IF NOT EXISTS idx_schedules_faculty ON schedules(faculty_id);
CREATE INDEX IF NOT EXISTS idx_schedules_course ON schedules(course_id);

-- Insert sample faculty data
INSERT INTO faculty (employee_id, first_name, last_name, email, phone, department, designation, hire_date, salary, qualification, experience_years, address) VALUES
('FAC001', 'John', 'Smith', 'john.smith@college.edu', '+1234567800', 'Computer Science and Engineering', 'Professor', '2010-08-15', 95000.00, 'Ph.D. in Computer Science', 15, '100 Faculty Lane, City, State'),
('FAC002', 'Sarah', 'Johnson', 'sarah.johnson@college.edu', '+1234567801', 'Electronics and Communication Engineering', 'Associate Professor', '2015-07-01', 80000.00, 'Ph.D. in Electronics Engineering', 10, '200 Faculty Lane, City, State'),
('FAC003', 'Michael', 'Brown', 'michael.brown@college.edu', '+1234567802', 'Mechanical Engineering', 'Professor', '2008-09-01', 100000.00, 'Ph.D. in Mechanical Engineering', 18, '300 Faculty Lane, City, State'),
('FAC004', 'Emily', 'Davis', 'emily.davis@college.edu', '+1234567803', 'Civil Engineering', 'Associate Professor', '2012-06-15', 85000.00, 'Ph.D. in Civil Engineering', 12, '400 Faculty Lane, City, State'),
('FAC005', 'David', 'Wilson', 'david.wilson@college.edu', '+1234567804', 'Information Technology', 'Assistant Professor', '2018-08-20', 70000.00, 'Ph.D. in Information Technology', 6, '500 Faculty Lane, City, State'),
('FAC006', 'Lisa', 'Anderson', 'lisa.anderson@college.edu', '+1234567805', 'Computer Science and Engineering', 'Assistant Professor', '2020-01-10', 65000.00, 'Ph.D. in Computer Science', 4, '600 Faculty Lane, City, State'),
('FAC007', 'Robert', 'Miller', 'robert.miller@college.edu', '+1234567806', 'Electronics and Communication Engineering', 'Professor', '2005-03-20', 105000.00, 'Ph.D. in Electronics Engineering', 20, '700 Faculty Lane, City, State')
ON CONFLICT (employee_id) DO NOTHING;

-- Insert sample courses
INSERT INTO courses (course_code, course_name, faculty_id, credits, department, semester, year, max_students, description, prerequisites) VALUES
('CS101', 'Introduction to Programming', 1, 4, 'Computer Science and Engineering', 1, 1, 60, 'Basic programming concepts using Python', 'None'),
('CS201', 'Data Structures and Algorithms', 1, 4, 'Computer Science and Engineering', 1, 2, 50, 'Fundamental data structures and algorithms', 'CS101'),
('CS301', 'Database Management Systems', 6, 3, 'Computer Science and Engineering', 1, 3, 40, 'Relational database design and SQL', 'CS201'),
('EC101', 'Circuit Analysis', 2, 4, 'Electronics and Communication Engineering', 1, 1, 55, 'Basic electrical circuit analysis', 'None'),
('EC201', 'Digital Electronics', 7, 3, 'Electronics and Communication Engineering', 2, 2, 45, 'Digital logic design and circuits', 'EC101'),
('ME101', 'Engineering Mechanics', 3, 4, 'Mechanical Engineering', 1, 1, 50, 'Statics and dynamics of mechanical systems', 'None'),
('CE101', 'Engineering Drawing', 4, 2, 'Civil Engineering', 1, 1, 40, 'Technical drawing and CAD basics', 'None'),
('IT101', 'Web Technologies', 5, 3, 'Information Technology', 2, 1, 45, 'HTML, CSS, JavaScript fundamentals', 'None')
ON CONFLICT (course_code) DO NOTHING;

-- Insert faculty-course assignments
INSERT INTO faculty_courses (faculty_id, course_id, academic_year, semester, role) VALUES
(1, 1, 2024, 1, 'INSTRUCTOR'),
(1, 2, 2024, 1, 'INSTRUCTOR'),
(6, 3, 2024, 1, 'INSTRUCTOR'),
(2, 4, 2024, 1, 'INSTRUCTOR'),
(7, 5, 2024, 2, 'INSTRUCTOR'),
(3, 6, 2024, 1, 'INSTRUCTOR'),
(4, 7, 2024, 1, 'INSTRUCTOR'),
(5, 8, 2024, 2, 'INSTRUCTOR')
ON CONFLICT (faculty_id, course_id, academic_year, semester) DO NOTHING;

-- Insert sample schedules
INSERT INTO schedules (faculty_id, course_id, day_of_week, start_time, end_time, room_number, academic_year, semester) VALUES
(1, 1, 'MONDAY', '09:00:00', '10:30:00', 'CS-101', 2024, 1),
(1, 1, 'WEDNESDAY', '09:00:00', '10:30:00', 'CS-101', 2024, 1),
(1, 2, 'TUESDAY', '11:00:00', '12:30:00', 'CS-102', 2024, 1),
(1, 2, 'THURSDAY', '11:00:00', '12:30:00', 'CS-102', 2024, 1),
(6, 3, 'MONDAY', '14:00:00', '15:30:00', 'CS-103', 2024, 1),
(6, 3, 'FRIDAY', '14:00:00', '15:30:00', 'CS-103', 2024, 1),
(2, 4, 'TUESDAY', '09:00:00', '10:30:00', 'EC-101', 2024, 1),
(2, 4, 'THURSDAY', '09:00:00', '10:30:00', 'EC-101', 2024, 1),
(7, 5, 'WEDNESDAY', '11:00:00', '12:30:00', 'EC-102', 2024, 2),
(7, 5, 'FRIDAY', '11:00:00', '12:30:00', 'EC-102', 2024, 2)
ON CONFLICT DO NOTHING;

-- Insert sample research projects
INSERT INTO research_projects (project_title, principal_investigator, funding_amount, start_date, end_date, status, description) VALUES
('Machine Learning for Healthcare Applications', 1, 250000.00, '2023-01-01', '2025-12-31', 'ACTIVE', 'Developing ML algorithms for medical diagnosis'),
('IoT Security Framework', 2, 180000.00, '2023-06-01', '2026-05-31', 'ACTIVE', 'Security protocols for IoT devices'),
('Sustainable Manufacturing Processes', 3, 300000.00, '2022-09-01', '2025-08-31', 'ACTIVE', 'Green manufacturing techniques'),
('Smart City Infrastructure', 4, 220000.00, '2023-03-01', '2026-02-28', 'ACTIVE', 'Intelligent urban planning systems'),
('Blockchain in Education', 5, 150000.00, '2023-08-01', '2025-07-31', 'ACTIVE', 'Decentralized education platforms')
ON CONFLICT DO NOTHING;

-- Insert sample performance reviews
INSERT INTO performance_reviews (faculty_id, review_period, teaching_rating, research_rating, service_rating, overall_rating, comments, reviewer_name, review_date) VALUES
(1, '2023-2024', 4.5, 4.8, 4.2, 4.5, 'Excellent research output and teaching quality', 'Dr. Academic Dean', '2024-06-15'),
(2, '2023-2024', 4.2, 4.0, 4.5, 4.2, 'Strong service contribution and good teaching', 'Dr. Academic Dean', '2024-06-15'),
(3, '2023-2024', 4.0, 4.5, 3.8, 4.1, 'Outstanding research with good teaching performance', 'Dr. Academic Dean', '2024-06-15'),
(4, '2023-2024', 4.3, 3.9, 4.4, 4.2, 'Excellent service and consistent teaching quality', 'Dr. Academic Dean', '2024-06-15'),
(5, '2023-2024', 4.1, 3.7, 4.0, 3.9, 'Good overall performance with room for improvement', 'Dr. Academic Dean', '2024-06-15')
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
CREATE TRIGGER update_faculty_updated_at BEFORE UPDATE ON faculty
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_courses_updated_at BEFORE UPDATE ON courses
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_schedules_updated_at BEFORE UPDATE ON schedules
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_research_projects_updated_at BEFORE UPDATE ON research_projects
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Grant necessary permissions
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO faculty_user;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO faculty_user;