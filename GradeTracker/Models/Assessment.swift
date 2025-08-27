//
//  Assessment.swift
//  GradeTracker
//
//  Created by Snigdha Tiwari on 27/08/2025.
//

import SwiftUI
import SwiftData
import Foundation

enum AssessmentType: String, CaseIterable, Codable {
    case exam = "Exam"
    case coursework = "Coursework"
    case essay = "Essay"
    case presentation = "Presentation"
    case project = "Project"
    case labWork = "Lab Work"
    case quiz = "Quiz"
    case assignment = "Assignment"
    case participation = "Participation"
    case dissertation = "Dissertation"
}

@Model
class Assessment {
    @Attribute(.unique) var id: UUID
    var title: String
    var type: AssessmentType
    var weighting: Double
    var dueDate: Date
    var grade: Double?
    var isCompleted: Bool
    var notes: String
    var module: Module?
    
    init(title: String, type: AssessmentType, weighting: Double, dueDate: Date, grade: Double? = nil, isCompleted: Bool = false, notes: String = "") {
        self.id = UUID()
        self.title = title
        self.type = type
        self.weighting = weighting
        self.dueDate = dueDate
        self.grade = grade
        self.isCompleted = isCompleted
        self.notes = notes
    }
    
    var isOverdue: Bool {
        return !isCompleted && dueDate < Date()
    }
    
    var formattedDueDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: dueDate)
    }
}
