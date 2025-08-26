//
//  Constants.swift
//  GradeTracker
//
//  Created by Snigdha Tiwari  on 26/08/2025.
//

import Foundation
import SwiftUI

struct AppConstants {
    // MARK: - UI Constants
    struct UI {
        static let cornerRadius: CGFloat = 12
        static let shadowRadius: CGFloat = 8
        static let cardPadding: CGFloat = 16
        static let sectionSpacing: CGFloat = 20
        static let itemSpacing: CGFloat = 12
        
        // Animation durations
        static let fastAnimation: Double = 0.2
        static let standardAnimation: Double = 0.3
        static let slowAnimation: Double = 0.5
    }
    
    // MARK: - Grade Constants
    struct Grades {
        // UK System
        struct UK {
            static let firstClassThreshold: Double = 70
            static let upperSecondThreshold: Double = 60
            static let lowerSecondThreshold: Double = 50
            static let thirdClassThreshold: Double = 40
            static let passThreshold: Double = 40
            
            static let maxGrade: Double = 100
            static let minGrade: Double = 0
            
            static let targetGrade: Double = 65 // 2:1 target
        }
        
        // US System
        struct US {
            static let maxGPA: Double = 4.0
            static let minGPA: Double = 0.0
            static let targetGPA: Double = 3.0 // B average
            
            static let aThreshold: Double = 3.7
            static let bThreshold: Double = 3.0
            static let cThreshold: Double = 2.0
            static let dThreshold: Double = 1.0
        }
    }
    
    // MARK: - Academic Constants
    struct Academic {
        // Common credit values
        static let ukStandardCredits = [15, 20, 30, 60, 120]
        static let usStandardCredits = [1, 2, 3, 4, 6]
        
        // Year weightings (UK system)
        static let yearWeightings: [Int: Double] = [
            1: 0.0,  // Year 1 doesn't count
            2: 1.0,  // Year 2 counts fully
            3: 1.0,  // Year 3 counts fully
            4: 1.0   // Year 4 (if applicable) counts fully
        ]
        
        // Semester names
        static let semesterNames = [
            "Semester 1", "Semester 2", "Semester 3",
            "Fall", "Spring", "Summer",
            "Autumn", "Winter"
        ]
    }
    
    // MARK: - Color Schemes
    struct Colors {
        static let gradeColors: [String: Color] = [
            "excellent": .green,
            "good": .blue,
            "satisfactory": .orange,
            "poor": .red,
            "fail": .gray
        ]
        
        static let moduleColors = [
            "blue", "green", "orange", "purple",
            "red", "teal", "pink", "indigo"
        ]
        
        static let priorityColors: [String: Color] = [
            "high": .red,
            "medium": .orange,
            "low": .green,
            "completed": .gray
        ]
    }
    
    // MARK: - Assessment Types
    static let assessmentTypes: [AssessmentType] = [
        .exam, .coursework, .essay, .presentation,
        .labWork, .project, .participation, .quiz, .dissertation
    ]
    
    // MARK: - Default Values
    struct Defaults {
        static let courseDurationYears = 3
        static let maxAssessmentsPerModule = 10
        static let maxModulesPerYear = 8
        
        // Progress thresholds
        static let excellentThreshold = 0.9
        static let goodThreshold = 0.75
        static let satisfactoryThreshold = 0.6
    }
    
    // MARK: - Date Formats
    struct DateFormats {
        static let displayDate = "MMM d, yyyy"
        static let shortDate = "MMM d"
        static let academicYear = "yyyy/yyyy"
        static let monthYear = "MMMM yyyy"
    }
    
    // MARK: - Validation Rules
    struct Validation {
        static let minGradePercentage: Double = 0
        static let maxGradePercentage: Double = 100
        static let minCredits = 1
        static let maxCredits = 120
        static let maxStudentNameLength = 50
        static let maxModuleNameLength = 100
        static let maxAssessmentNameLength = 80
    }
}

// MARK: - Computed Properties Extensions
extension AppConstants.Grades.UK {
    static func getClassification(for grade: Double) -> String {
        switch grade {
        case firstClassThreshold...: return "First Class"
        case upperSecondThreshold..<firstClassThreshold: return "Upper Second (2:1)"
        case lowerSecondThreshold..<upperSecondThreshold: return "Lower Second (2:2)"
        case thirdClassThreshold..<lowerSecondThreshold: return "Third Class"
        default: return "Fail"
        }
    }
    
    static func getColor(for grade: Double) -> Color {
        switch grade {
        case firstClassThreshold...: return .green
        case upperSecondThreshold..<firstClassThreshold: return .blue
        case lowerSecondThreshold..<upperSecondThreshold: return .orange
        case thirdClassThreshold..<lowerSecondThreshold: return .red
        default: return .gray
        }
    }
}

extension AppConstants.Grades.US {
    static func getLetterGrade(for gpa: Double) -> String {
        switch gpa {
        case aThreshold...: return "A"
        case bThreshold..<aThreshold: return "B"
        case cThreshold..<bThreshold: return "C"
        case dThreshold..<cThreshold: return "D"
        default: return "F"
        }
    }
    
    static func getColor(for gpa: Double) -> Color {
        switch gpa {
        case aThreshold...: return .green
        case bThreshold..<aThreshold: return .blue
        case cThreshold..<bThreshold: return .orange
        case dThreshold..<cThreshold: return .red
        default: return .gray
        }
    }
}

// MARK: - Helper Functions
extension AppConstants {
    static func formatGrade(_ grade: Double, system: GradingSystem) -> String {
        switch system {
        case .uk:
            return String(format: "%.1f%%", grade)
        case .us:
            return String(format: "%.2f", grade)
        }
    }
    
    static func getTargetGrade(for system: GradingSystem) -> Double {
        switch system {
        case .uk:
            return Grades.UK.targetGrade
        case .us:
            return Grades.US.targetGPA
        }
    }
    
    static func isExcellentGrade(_ grade: Double, system: GradingSystem) -> Bool {
        switch system {
        case .uk:
            return grade >= Grades.UK.firstClassThreshold
        case .us:
            return grade >= Grades.US.aThreshold
        }
    }
}
