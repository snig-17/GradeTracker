//
//  AcademicYear.swift
//  GradeTracker
//
//  Created by Snigdha Tiwari on 27/08/2025.
//

import SwiftData
import Foundation

@Model
class AcademicYear {
    @Attribute(.unique) var id: UUID
    var name: String
    var startDate: Date
    var endDate: Date
    var weightingMultiplier: Double
    var isActive: Bool
    @Relationship(deleteRule: .cascade) var modules: [Module]
    var student: Student?
    
    init(name: String, startDate: Date, endDate: Date, weightingMultiplier: Double, isActive: Bool = false) {
        self.id = UUID()
        self.name = name
        self.startDate = startDate
        self.endDate = endDate
        self.weightingMultiplier = weightingMultiplier
        self.isActive = isActive
        self.modules = []
    }
    
    // Computed property for year GPA
    var yearGPA: Double {
        let validModules = modules.compactMap { $0.currentGrade }
        guard !validModules.isEmpty else { return 0.0 }
        
        let totalCredits = modules.reduce(0) { $0 + $1.credits }
        guard totalCredits > 0 else { return 0.0 }
        
        let weightedSum = modules.compactMap { module -> Double? in
            guard let grade = module.currentGrade else { return nil }
            return grade * Double(module.credits)
        }.reduce(0, +)
        
        return weightedSum / Double(totalCredits)
    }
    
    // Computed property for total credits
    var totalCredits: Int {
        return modules.reduce(0) { $0 + $1.credits }
    }
    
    // Computed property for completed credits
    var completedCredits: Int {
        return modules.filter { $0.isCompleted }.reduce(0) { $0 + $1.credits }
    }
    
    // Computed property for completed modules count
    var completedModules: Int {
        return modules.filter { $0.isCompleted }.count
    }
    
    // Computed property for in-progress modules count
    var inProgressModules: Int {
        return modules.filter { !$0.isCompleted }.count
    }
    
    // Computed property for all assessments in this year
    var allAssessments: [Assessment] {
        return modules.flatMap { $0.assessments }
    }
    
    // Computed property for upcoming assessments
    var upcomingAssessments: [Assessment] {
        return allAssessments.filter { !$0.isCompleted && $0.dueDate >= Date() }
            .sorted { $0.dueDate < $1.dueDate }
    }
}
