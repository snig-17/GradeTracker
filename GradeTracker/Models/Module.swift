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
    @Relationship(deleteRule: .cascade) var assessments: [Assessment]
    var academicYearRef: AcademicYear?
    
    init(name: String, code: String, credits: Int, semester: String, academicYear: String, lecturer: String = "", description: String = "", colorHex: String = "#007AFF", gradeSystem: GradeSystem = .uk, isCompleted: Bool = false) {
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
        self.assessments = []
    }
    
    // Computed property for current grade
    var currentGrade: Double? {
        let completedAssessments = assessments.compactMap { $0.grade }
        guard !completedAssessments.isEmpty else { return nil }
        
        let totalWeighting = assessments.filter { $0.grade != nil }.reduce(0) { $0 + $1.weighting }
        guard totalWeighting > 0 else { return nil }
        
        let weightedSum = assessments.compactMap { assessment in
            guard let grade = assessment.grade else { return nil }
            return grade * (assessment.weighting / 100.0)
        }.reduce(0, +)
        
        return (weightedSum / totalWeighting) * 100
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
}
