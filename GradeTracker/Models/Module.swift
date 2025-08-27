//
//  Module.swift
//  GradeTracker
//
//  Created by Snigdha Tiwari on 27/08/2025.
//

import SwiftUI
import SwiftData
import Foundation

@Model
class Module {
    @Attribute(.unique) var id: UUID
    var name: String
    var code: String
    var credits: Int
    var semester: String
    var academicYear: String
    var lecturer: String
    var moduleDescription: String
    var colorHex: String
    var gradeSystem: GradeSystem
    var isCompleted: Bool
    var isCore: Bool // Whether this is a core module
    @Relationship(deleteRule: .cascade) var assessments: [Assessment]
    var academicYearRef: AcademicYear?
    
    init(name: String, code: String, credits: Int, semester: String, academicYear: String, lecturer: String = "", description: String = "", colorHex: String = "#007AFF", gradeSystem: GradeSystem = .uk, isCompleted: Bool = false, isCore: Bool = false) {
        self.id = UUID()
        self.name = name
        self.code = code
        self.credits = credits
        self.semester = semester
        self.academicYear = academicYear
        self.lecturer = lecturer
        self.moduleDescription = description
        self.colorHex = colorHex
        self.gradeSystem = gradeSystem
        self.isCompleted = isCompleted
        self.isCore = isCore
        self.assessments = []
    }
    
    // Computed property for current grade
    var currentGrade: Double? {
        let completedAssessments = assessments.filter { $0.grade != nil }
        guard !completedAssessments.isEmpty else { return nil }
        
        let completedWeighting = completedAssessments.reduce(0) { $0 + $1.weighting }
        guard completedWeighting > 0 else { return nil }
        
        let weightedSum = completedAssessments.reduce(0) { sum, assessment in
            return sum + (assessment.grade! * (assessment.weighting / 100.0))
        }
        
        // Return the weighted average of completed assessments
        return (weightedSum / (completedWeighting / 100.0))
    }
    
    // Computed property for completion status
    var completionStatus: String {
        if isCompleted {
            return "Completed"
        } else if assessments.allSatisfy({ $0.isCompleted }) && !assessments.isEmpty {
            return "All assessments complete"
        } else {
            return "In progress"
        }
    }
    
    // Computed property for total assessment weighting
    var totalWeighting: Double {
        return assessments.reduce(0) { $0 + $1.weighting }
    }
    
    // Computed property for remaining weighting
    var remainingWeighting: Double {
        return max(0, 100 - totalWeighting)
    }
    
    // Computed property for upcoming assessments
    var upcomingAssessments: [Assessment] {
        return assessments.filter { !$0.isCompleted && $0.dueDate >= Date() }
            .sorted { $0.dueDate < $1.dueDate }
    }
    
    // Computed property for overdue assessments
    var overdueAssessments: [Assessment] {
        return assessments.filter { !$0.isCompleted && $0.dueDate < Date() }
    }
    
    // Computed property for color (returns hex string converted to color)
    var color: String {
        return colorHex // Return hex string for use in Color(hex:) extension
    }
    
    // Computed property for final grade (uses currentGrade)
    var finalGrade: Double {
        return currentGrade ?? 0.0
    }
    
    // Computed property for completion percentage
    var completionPercentage: Double {
        guard !assessments.isEmpty else { return 0.0 }
        let completedAssessments = assessments.filter { $0.isCompleted }
        return Double(completedAssessments.count) / Double(assessments.count)
    }
}
