//
//  Student.swift
//  GradeTracker
//
//  Created by Snigdha Tiwari on 27/08/2025.
//

import SwiftData
import Foundation

@Model
class Student {
    @Attribute(.unique) var id: UUID
    var name: String
    var studentNumber: String
    var university: String
    var course: String
    var systemType: GradeSystem
    var startYear: Int
    var expectedGraduation: Int
    @Relationship(deleteRule: .cascade) var academicYears: [AcademicYear]
    var createdDate: Date
    
    init(name: String, studentNumber: String, university: String, course: String, systemType: GradeSystem, startYear: Int) {
        self.id = UUID()
        self.name = name
        self.studentNumber = studentNumber
        self.university = university
        self.course = course
        self.systemType = systemType
        self.startYear = startYear
        self.expectedGraduation = startYear + 3
        self.academicYears = []
        self.createdDate = Date()
    }
    
    // Computed properties
    var overallGPA: Double {
        let validYears = academicYears.filter { $0.weightingMultiplier > 0 }
        guard !validYears.isEmpty else { return 0.0 }
        
        let totalWeightedGrades = validYears.reduce(0.0) { sum, year in
            return sum + (year.yearGPA * year.weightingMultiplier)
        }
        let totalWeighting = validYears.reduce(0.0) { $0 + $1.weightingMultiplier }
        
        return totalWeighting > 0 ? totalWeightedGrades / totalWeighting : 0.0
    }
    
    var degreeClassification: String {
        let gpa = overallGPA
        switch systemType {
        case .uk:
            if gpa >= 70 { return "First Class Honours" }
            else if gpa >= 60 { return "Upper Second Class Honours" }
            else if gpa >= 50 { return "Lower Second Class Honours" }
            else if gpa >= 40 { return "Third Class Honours" }
            else { return "Below Honours Threshold" }
        case .us:
            if gpa >= 97 { return "A+" }
            else if gpa >= 93 { return "A" }
            else if gpa >= 90 { return "A-" }
            else if gpa >= 87 { return "B+" }
            else if gpa >= 83 { return "B" }
            else if gpa >= 80 { return "B-" }
            else if gpa >= 77 { return "C+" }
            else if gpa >= 73 { return "C" }
            else if gpa >= 70 { return "C-" }
            else if gpa >= 67 { return "D+" }
            else if gpa >= 63 { return "D" }
            else if gpa >= 60 { return "D-" }
            else { return "F" }
        }
    }
    
    var currentAcademicYear: AcademicYear? {
        return academicYears.first { $0.isActive }
    }
    
    var totalCredits: Int {
        return academicYears.reduce(0) { $0 + $1.totalCredits }
    }
    
    var completedCredits: Int {
        return academicYears.reduce(0) { $0 + $1.completedCredits }
    }
    
    var allModules: [Module] {
        return academicYears.flatMap { $0.modules }
    }
    
    var allUpcomingAssessments: [Assessment] {
        return academicYears.flatMap { $0.upcomingAssessments }.prefix(5).map { $0 }
    }
    
    // Static method to create sample student
    static func createSampleStudent() -> Student {
        let student = Student(
            name: "Santosh Kumar",
            studentNumber: "ST2024001",
            university: "University of Technology",
            course: "Computer Science",
            systemType: .uk,
            startYear: 2024
        )
        
        // Create academic year
        let year2024 = AcademicYear(
            name: "Year 2",
            startDate: Calendar.current.date(from: DateComponents(year: 2024, month: 9, day: 1)) ?? Date(),
            endDate: Calendar.current.date(from: DateComponents(year: 2025, month: 6, day: 30)) ?? Date(),
            weightingMultiplier: 0.5,
            isActive: true
        )
        
        // Create sample modules
        let softwareEngineering = Module(
            name: "Software Engineering",
            code: "COMP2001",
            credits: 20,
            semester: "Semester 1",
            academicYear: "2024-25",
            lecturer: "Dr. Smith",
            description: "Advanced software engineering principles and practices",
            colorHex: "#007AFF",
            gradeSystem: .uk,
            isCompleted: false
        )
        
        let databases = Module(
            name: "Database Systems",
            code: "COMP2002",
            credits: 20,
            semester: "Semester 1",
            academicYear: "2024-25",
            lecturer: "Prof. Johnson",
            description: "Relational database design and SQL programming",
            colorHex: "#34C759",
            gradeSystem: .uk,
            isCompleted: false
        )
        
        let algorithms = Module(
            name: "Algorithms & Data Structures",
            code: "COMP2003",
            credits: 20,
            semester: "Semester 2",
            academicYear: "2024-25",
            lecturer: "Dr. Williams",
            description: "Advanced algorithms and data structure implementation",
            colorHex: "#FF9500",
            gradeSystem: .uk,
            isCompleted: false
        )
        
        // Create sample assessments for Software Engineering
        let seCoursework = Assessment(
            title: "Group Project",
            type: .project,
            weighting: 40.0,
            dueDate: Calendar.current.date(byAdding: .day, value: 14, to: Date()) ?? Date(),
            grade: 68.0,
            isCompleted: true,
            notes: "Excellent teamwork and implementation"
        )
        
        let seExam = Assessment(
            title: "Final Exam",
            type: .exam,
            weighting: 60.0,
            dueDate: Calendar.current.date(byAdding: .day, value: 45, to: Date()) ?? Date(),
            grade: nil,
            isCompleted: false,
            notes: ""
        )
        
        // Create sample assessments for Database Systems
        let dbCoursework = Assessment(
            title: "SQL Assignment",
            type: .coursework,
            weighting: 30.0,
            dueDate: Calendar.current.date(byAdding: .day, value: 7, to: Date()) ?? Date(),
            grade: 72.0,
            isCompleted: true,
            notes: "Good understanding of SQL concepts"
        )
        
        let dbExam = Assessment(
            title: "Database Theory Exam",
            type: .exam,
            weighting: 70.0,
            dueDate: Calendar.current.date(byAdding: .day, value: 50, to: Date()) ?? Date(),
            grade: nil,
            isCompleted: false,
            notes: ""
        )
        
        // Create sample assessments for Algorithms
        let algoAssignment = Assessment(
            title: "Algorithm Implementation",
            type: .assignment,
            weighting: 50.0,
            dueDate: Calendar.current.date(byAdding: .day, value: 21, to: Date()) ?? Date(),
            grade: nil,
            isCompleted: false,
            notes: ""
        )
        
        let algoExam = Assessment(
            title: "Algorithms Final Exam",
            type: .exam,
            weighting: 50.0,
            dueDate: Calendar.current.date(byAdding: .day, value: 60, to: Date()) ?? Date(),
            grade: nil,
            isCompleted: false,
            notes: ""
        )
        
        // Link assessments to modules
        softwareEngineering.assessments = [seCoursework, seExam]
        databases.assessments = [dbCoursework, dbExam]
        algorithms.assessments = [algoAssignment, algoExam]
        
        // Set module references in assessments
        seCoursework.module = softwareEngineering
        seExam.module = softwareEngineering
        dbCoursework.module = databases
        dbExam.module = databases
        algoAssignment.module = algorithms
        algoExam.module = algorithms
        
        // Link modules to academic year
        year2024.modules = [softwareEngineering, databases, algorithms]
        softwareEngineering.academicYearRef = year2024
        databases.academicYearRef = year2024
        algorithms.academicYearRef = year2024
        
        // Link academic year to student
        student.academicYears = [year2024]
        year2024.student = student
        
        return student
    }
}
