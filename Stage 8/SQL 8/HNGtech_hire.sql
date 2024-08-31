-- Create HNGTech_Hire_Database
CREATE DATABASE IF NOT EXISTS HNGTech_Hire_Database;
-- Use the HNGTech_Hire_Database
USE HNGtech_Hire_Database;

-- Create Date Table
CREATE TABLE IF NOT EXISTS date (
    date_id INT AUTO_INCREMENT PRIMARY KEY,
    date DATE NOT NULL,
    day_of_week VARCHAR(10),
    month INT,
    quarter INT,
    year INT
);

-- Create Location Table
CREATE TABLE IF NOT EXISTS location (
  location_id INT AUTO_INCREMENT PRIMARY KEY,
  city VARCHAR(100),
  state VARCHAR(100),
  country VARCHAR(100)
);

-- Create TechStack Table
CREATE TABLE IF NOT EXISTS tech_stack (
  stack_id INT AUTO_INCREMENT PRIMARY KEY,
  stack_name VARCHAR(100)
);

-- Create Skill Table (New Table)
CREATE TABLE IF NOT EXISTS skill (
  skill_id INT AUTO_INCREMENT PRIMARY KEY,
  skill_name VARCHAR(100)
);

-- Create Company Table 
CREATE TABLE IF NOT EXISTS company (
  company_id INT AUTO_INCREMENT PRIMARY KEY,
  company_name VARCHAR(100),
  industry VARCHAR(100),
  location_id INT,
  FOREIGN KEY (location_id) REFERENCES location(location_id)
);

-- Create Recruiter Table
CREATE TABLE IF NOT EXISTS recruiter (
  recruiter_id INT AUTO_INCREMENT PRIMARY KEY,
  full_name VARCHAR(100),
  email VARCHAR(100) UNIQUE,
  phone_number VARCHAR(15),
  company_id INT,
  recruiter_status ENUM('Active', 'Inactive'),
  FOREIGN KEY (company_id) REFERENCES company(company_id)
);

-- Create Candidate Table 
CREATE TABLE IF NOT EXISTS candidate (
  candidate_id INT AUTO_INCREMENT PRIMARY KEY,
  full_name VARCHAR(100),
  email VARCHAR(100) UNIQUE,
  phone_number VARCHAR(15),
  location_id INT,
  stack_id INT,
  experience_level ENUM('Entry', 'Junior', 'Mid', 'Senior'),
  current_status ENUM('Available', 'Interviewing', 'Hired', 'Not Available'),
  career_goals TEXT,
  FOREIGN KEY (location_id) REFERENCES location(location_id),
  FOREIGN KEY (stack_id) REFERENCES tech_stack(stack_id)
);

-- Create Candidate Skill Relationship 
CREATE TABLE IF NOT EXISTS candidate_skill (
  candidate_id INT,
  skill_id INT,
  PRIMARY KEY (candidate_id, skill_id),
  FOREIGN KEY (candidate_id) REFERENCES candidate(candidate_id),
  FOREIGN KEY (skill_id) REFERENCES skill(skill_id)
);

-- Create Job Postings Table 
CREATE TABLE IF NOT EXISTS job_postings (
  job_id INT AUTO_INCREMENT PRIMARY KEY,
  job_title VARCHAR(100),
  job_description TEXT
);

-- Create Application Table
CREATE TABLE IF NOT EXISTS application (
  application_id INT AUTO_INCREMENT PRIMARY KEY,
  candidate_id INT,
  job_id INT,
  application_date_id INT,
  application_status ENUM('Pending', 'Interviewing', 'Rejected', 'Hired') DEFAULT 'Pending',
  FOREIGN KEY (candidate_id) REFERENCES candidate(candidate_id),
  FOREIGN KEY (job_id) REFERENCES job_postings(job_id)
);

-- Create Interview Table
CREATE TABLE IF NOT EXISTS interview (
    interview_id INT AUTO_INCREMENT PRIMARY KEY,
    application_id INT,
    interview_date_id INT,
    interviewer VARCHAR(100),
    interview_result ENUM('Passed', 'Failed', 'Pending'),
    FOREIGN KEY (application_id) REFERENCES application(application_id),
    FOREIGN KEY (interview_date_id) REFERENCES date(date_id)
);

-- Create Hiring Decisions Table
CREATE TABLE IF NOT EXISTS hiring_decision (
    decision_id INT AUTO_INCREMENT PRIMARY KEY,
    application_id INT,
    decision_date_id INT,
    decision ENUM('Hired', 'Rejected', 'Pending'),
    comments TEXT,
    FOREIGN KEY (application_id) REFERENCES application(application_id),
    FOREIGN KEY (decision_date_id) REFERENCES date(date_id)
);
-- Inserting Dummy Data into Date Table
INSERT INTO date (date, day_of_week, month, quarter, year) VALUES
('2024-01-01', 'Monday', 1, 1, 2024),
('2024-02-15', 'Thursday', 2, 1, 2024),
('2024-03-20', 'Wednesday', 3, 1, 2024),
('2024-04-10', 'Wednesday', 4, 2, 2024),
('2024-05-05', 'Sunday', 5, 2, 2024),
('2024-06-01', 'Saturday', 6, 2, 2024),
('2024-07-04', 'Thursday', 7, 3, 2024),
('2024-08-12', 'Monday', 8, 3, 2024),
('2024-09-16', 'Monday', 9, 3, 2024),
('2024-10-25', 'Friday', 10, 4, 2024);

-- Inserting Dummy Data into Location Table
INSERT INTO location (city, state, country) VALUES
('New York', 'NY', 'USA'),
('London', 'England', 'UK'),
('Tokyo', 'Tokyo', 'Japan'),
('Berlin', 'Berlin', 'Germany'),
('Paris', 'Île-de-France', 'France'),
('Sydney', 'New South Wales', 'Australia'),
('Mumbai', 'Maharashtra', 'India'),
('São Paulo', 'São Paulo', 'Brazil'),
('Moscow', 'Moscow', 'Russia'),
('Beijing', 'Beijing', 'China');

-- Inserting Dummy Data into Tech_stack Table
INSERT INTO tech_stack (stack_name) VALUES
('Frontend Development'),
('Backend Development'),
('Full-Stack Development'),
('Mobile App Development'),
('Data Science'),
('DevOps'),
('UI/UX Design'),
('Product Management'),
('Cybersecurity'),
('Cloud Computing');

-- Inserting Dummy Data into Skill Table
INSERT INTO skill (skill_name) VALUES
('HTML'),
('CSS'),
('JavaScript'),
('Python'),
('Java'),
('C++'),
('SQL'),
('React'),
('Vue.js'),
('Angular'),
('Node.js'),
('Git'),
('AWS'),
('Azure'),
('Google Cloud Platform'),
('Machine Learning'),
('Data Analysis'),
('Agile Methodology'),
('Scrum'),
('Kanban');

-- Inserting Dummy Data into Company Table
INSERT INTO company (company_name, industry, location_id) VALUES
('TechGiant', 'Technology', 1),
('FinTech Solutions', 'Finance', 2),
('HealthTech Innovations', 'Healthcare', 3),
('RetailRetail', 'Retail', 4),
('EduTech Academy', 'Education', 5),
('GreenEnergy Solutions', 'Energy', 6),
('TravelTrek', 'Travel', 7),
('GamingGalaxy', 'Gaming', 8),
('ManufacturingCorp', 'Manufacturing', 9),
('ConsultingFirm', 'Consulting', 10);

-- Inserting Dummy Data into Recruiter Table
INSERT INTO recruiter (full_name, email, phone_number, company_id, recruiter_status) VALUES
('Alice Johnson', 'alice.johnson@example.com', '123-456-7890', 1, 'Active'),
('Bob Smith', 'bob.smith@example.com', '098-765-4321', 2, 'Active'),
('Carol Davis', 'carol.davis@example.com', '555-555-5555', 3, 'Inactive'),
('David Brown', 'david.brown@example.com', '444-444-4444', 4, 'Active'),
('Eva Green', 'eva.green@example.com', '333-333-3333', 5, 'Active'),
('Frank White', 'frank.white@example.com', '222-222-2222', 6, 'Inactive'),
('Grace Lee', 'grace.lee@example.com', '111-111-1111', 7, 'Active'),
('Henry Black', 'henry.black@example.com', '666-666-6666', 8, 'Active'),
('Ivy Wilson', 'ivy.wilson@example.com', '777-777-7777', 9, 'Inactive'),
('Jack Brown', 'jack.brown@example.com', '888-888-8888', 10, 'Active');

-- Inserting Dummy Data into Candidate Table
INSERT INTO candidate (full_name, email, phone_number, location_id, stack_id, experience_level, current_status, career_goals) VALUES
('John Doe', 'john.doe@example.com', '111-111-1111', 1, 1, 'Entry', 'Available', 'Looking for frontend roles.'),
('Jane Roe', 'jane.roe@example.com', '222-222-2222', 2, 2, 'Junior', 'Available', 'Interested in backend development.'),
('Mike Smith', 'mike.smith@example.com', '333-333-3333', 3, 3, 'Mid', 'Interviewing', 'Seeking full-stack opportunities.'),
('Lucy Brown', 'lucy.brown@example.com', '444-444-4444', 4, 4, 'Senior', 'Available', 'Experienced in DevOps.'),
('Tom Clark', 'tom.clark@example.com', '555-555-5555', 5, 5, 'Entry', 'Not Available', 'New to data science.'),
('Emily Davis', 'emily.davis@example.com', '666-666-6666', 6, 6, 'Junior', 'Available', 'Looking for mobile development roles.'),
('Adam White', 'adam.white@example.com', '777-777-7777', 7, 7, 'Mid', 'Interviewing', 'Experienced in QA.'),
('Olivia Johnson', 'olivia.johnson@example.com', '888-888-8888', 8, 8, 'Senior', 'Hired', 'UI/UX design expert.'),
('Sophia Lee', 'sophia.lee@example.com', '999-999-9999', 9, 9, 'Entry', 'Available', 'Starting out in blockchain.'),
('Daniel Brown', 'daniel.brown@example.com', '000-000-0000', 10, 10, 'Junior', 'Interviewing', 'Interested in cloud computing.');

-- Inserting Dummy Data into Candidate_skill Table
INSERT INTO candidate_skill (candidate_id, skill_id) VALUES
(1, 1),
(1, 2),
(2, 3),
(2, 4),
(3, 5),
(3, 6),
(4, 7),
(4, 8),
(5, 9),
(5, 10);

-- Inserting Dummy Data into job_postings Table
INSERT INTO job_postings (job_title, job_description) VALUES
('Frontend Developer', 'Build and maintain the front end of our web applications.'),
('Backend Developer', 'Develop server-side logic and integrate with front end applications.'),
('Full-Stack Developer', 'Work on both frontend and backend development.'),
('Data Scientist', 'Analyze data to provide insights and support decision-making.'),
('DevOps Engineer', 'Optimize and automate our deployment pipelines and infrastructure.'),
('UI/UX Designer', 'Create and implement design strategies to improve product usability.'),
('Product Manager', 'Oversee product development and strategy.'),
('Cybersecurity Analyst', 'Protect our systems and data from security threats.'),
('Cloud Architect', 'Design and implement cloud-based solutions.'),
('Mobile App Developer', 'Create and maintain mobile applications for iOS and Android.');

-- Inserting Dummy Data into Application Table
INSERT INTO application (candidate_id, job_id, application_date_id, application_status) VALUES
(1, 1, 1, 'Pending'),
(2, 2, 2, 'Interviewing'),
(3, 3, 3, 'Rejected'),
(4, 4, 4, 'Pending'),
(5, 5, 5, 'Hired'),
(6, 6, 6, 'Pending'),
(7, 7, 7, 'Interviewing'),
(8, 8, 8, 'Pending'),
(9, 9, 9, 'Rejected'),
(10, 10, 10, 'Hired');

-- Inserting Dummy Data into Interview Table
INSERT INTO interview (application_id, interview_date_id, interviewer) VALUES
(1, 1, 'Emily Taylor'),
(2, 2, 'Michael Brown'),
(3, 3, 'Sarah Lee'),
(4, 4, 'James Wilson'),
(5, 5, 'Laura King'),
(6, 6, 'Kevin Hall'),
(7, 7, 'Nancy Adams'),
(8, 8, 'Paul Davis'),
(9, 9, 'Linda Miller'),
(10, 10, 'Tom Scott');

-- Inserting Dummy Data into Hiring Decisions Table
INSERT INTO hiring_decision (application_id, decision_date_id, decision, comments) VALUES
(1, 1, 'Pending', 'Awaiting further review.'),
(2, 2, 'Rejected', 'Candidate did not meet the required criteria.'),
(3, 3, 'Hired', 'Offered the position with terms agreed.'),
(4, 4, 'Pending', 'Decision pending final review.'),
(5, 5, 'Rejected', 'Position filled with another candidate.'),
(6, 6, 'Hired', 'Accepted offer and agreed to start date.'),
(7, 7, 'Pending', 'Reviewing additional qualifications.'),
(8, 8, 'Rejected', 'No match for job requirements.'),
(9, 9, 'Hired', 'Candidate has accepted the position.'),
(10, 10, 'Hired', 'Contract signed and onboarding in progress.');

SELECT * FROM date;
SELECT * FROM location;
SELECT * FROM tech_stack;
SELECT * FROM skill;
SELECT * FROM company;
SELECT * FROM recruiter;
SELECT * FROM candidate;
SELECT * FROM candidate_skill;
SELECT * FROM job_postings;
SELECT * FROM application;
SELECT * FROM interview;
SELECT * FROM hiring_decision;
SELECT candidate_id, full_name FROM candidate;

