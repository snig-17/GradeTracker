import SwiftData
import Foundation

@Model
class Student {
    @Attribute(.unique) var id: UUID
    var name: String
    var studentNumber: String
    var university: String
    var course: String
    var systemType: GradingSystem
    var startYear: Int
    var expectedGraduation: Int
    @Relationship(deleteRule: .cascade) var academicYears: [AcademicYear]
    var createdDate: Date
    
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
        switch systemType {
        case .uk:
            return "First Class"  // Simplified for now
        case .us:
            return "A"
        }
    }
    
    init(name: String, studentNumber: String, university: String, course: String, systemType: GradingSystem, startYear: Int) {
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
}

// ✅ ADD THIS EXTENSION FOR SAMPLE DATA
extension Student {
    static var sampleStudent: Student {
        let student = Student(
            name: "Santosh Kumar",
            studentNumber: "12345678",
            university: "University of London",
            course: "Computer Science BSc",
            systemType: .uk,
            startYear: 2023
        )
        
        // Create sample academic year
        let year2024 = AcademicYear(
            name: "Year 2",
            level: 2,
            weightingMultiplier: 1.0,
            startDate: Calendar.current.date(from: DateComponents(year: 2024, month: 9, day: 1))!,
            endDate: Calendar.current.date(from: DateComponents(year: 2025, month: 6, day: 30))!
        )
        
        // Create sample modules
        let softwareEngineering = Module(
            name: "Software Engineering",
            code: "COMP2001",
            credits: 20,
            semester: "Semester 1",
            lecturer: "Dr. Smith",
            isCore: true
        )
        
        let databases = Module(
            name: "Database Systems",
            code: "COMP2002",
            credits: 20,
            semester: "Semester 1",
            lecturer: "Prof. Johnson",
            isCore: true
        )
        
        // Create sample assessments
        let seCoursework = Assessment(
            name: "Group Project",
            type: .project,
            weighting: 40.0,
            dueDate: Calendar.current.date(byAdding: .day, value: 14, to: Date())
        )
        seCoursework.percentage = 68.0
        seCoursework.isCompleted = true
        
        let seExam = Assessment(
            name: "Final Exam",
            type: .exam,
            weighting: 60.0,
            dueDate: Calendar.current.date(byAdding: .day, value: 45, to: Date())
        )
        
        softwareEngineering.assessments = [seCoursework, seExam]
        
        let dbCoursework = Assessment(
            name: "SQL Assignment",
            type: .coursework,
            weighting: 30.0,
            dueDate: Calendar.current.date(byAdding: .day, value: 7, to: Date())
        )
        
        databases.assessments = [dbCoursework]
        
        year2024.modules = [softwareEngineering, databases]
        year2024.isActive = true
        
        student.academicYears = [year2024]
        
        return student
    }
}

enum GradingSystem: String, CaseIterable, Codable {
    case uk = "UK System"
    case us = "US System"
    
    var displayName: String { rawValue }
}
