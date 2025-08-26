//
//  Assessment.swift
//  GradeTracker
//
//  Created by Snigdha Tiwari  on 26/08/2025.
//

import Foundation
import SwiftData

@Model
class Assessment {
    @Attribute(.unique)
    var id: UUID
    var name: String
    var type: AssessmentType
    var weighting: Double
    var percentage: Double
    var maxMarks: Double
    var achievedMarks: Double
    var dueDate: Date?
    var submissionDate: Date?
    var isCompleted: Bool
    var feedback: String
    var notes: String
    
    init(id: UUID, name: String, type: AssessmentType, weighting: Double, percentage: Double, maxMarks: Double, achievedMarks: Double, dueDate: Date? = nil, submissionDate: Date? = nil, isCompleted: Bool, feedback: String, notes: String) {
        self.id = id
        self.name = name
        self.type = type
        self.weighting = weighting
        self.percentage = percentage
        self.maxMarks = maxMarks
        self.achievedMarks = achievedMarks
        self.dueDate = dueDate
        self.submissionDate = submissionDate
        self.isCompleted = isCompleted
        self.feedback = feedback
        self.notes = notes
    }
}

