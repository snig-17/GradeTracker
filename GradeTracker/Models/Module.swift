//
//  Module.swift
//  GradeTracker
//
//  Created by Snigdha Tiwari  on 26/08/2025.
//

import Foundation
import SwiftData

@Model
class Module {
    @Attribute(.unique)
    var id: UUID
    var name: String
    var code: String
    var credits: Int
    var term: String
    var lecturer: String
    var isCore: Bool
    var assessments: [Assessment]
    var colour: String
    
    // MARK: - computed properties
    
    var finalGrade: Double {
        let totalWeighting = assessments.reduce(0.0){ $0 + $1.weighting}
        guard totalWeighting > 0 else { return 0.0 }
        
        return assessments.reduce(0.0) { sum, assessment in
            guard assessment.isCompleted else { return sum}
            return sum + (assessment.percentage * assessment.weighting / 100.0)
        }
    }
    
    var projectedGrade: Double {
        let completedWeighting = assessments.filter{ $0.isCompleted }.reduce(0.0) { $0 + $1.weighting}
        let remainingWeighting = 100.0 - completedWeighting
        if remainingWeighting <= 0 {return finalGrade}
        
        let currentPerformance = finalGrade
        let targetGrade = 100.0
        
        return currentPerformance + (targetGrade * remainingWeighting / 100.0)
    }
    
    var isCompleted: Bool {
        assessments.allSatisfy { $0.isCompleted }
    }
    
    var completionPercentage: Double {
        let totalWeighting = assessments.reduce(0.0) { $0 + $1.weighting}
        let completedWeighting = assessments.filter({ $0.isCompleted }).reduce(0.0) { $0 + $1.weighting}
        return totalWeighting > 0 ? completedWeighting / totalWeighting : 0.0.
    }
    
    init(id: UUID, name: String, code: String, credits: Int, term: String, lecturer: String, isCore: Bool, assessments: [Assessment], colour: String) {
        self.id = id
        self.name = name
        self.code = code
        self.credits = credits
        self.term = term
        self.lecturer = lecturer
        self.isCore = isCore
        self.assessments = assessments
        self.colour = colour
    }
}

enum ModuleColour: String, CaseIterable {
    case blue = "blue"
    case green = "green"
    case orange = "orange"
    case purple = "purple"
    case red = "red"
    case teal = "teal"
    case pink = "pink"
    case indigo = "indigo"
}
