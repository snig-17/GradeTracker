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
    
    // MARK: - computed properties
    var letterGrade: String {
        return GradeConverter.percentageToLetterGrade(percentage: percentage, system: .uk)
    }
    var isOverdue: Bool {
        guard let dueDate = dueDate else { return false }
        return !isCompleted && Date() > dueDate
    }
    var daysUntilDue: Int? {
        guard let dueDate = dueDate else { return nil }
        return Calendar.current.dateComponents([.day], from: Date(), to: dueDate).day
    }
    
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
enum AssessmentType: String, CaseIterable, Codeable {
    case exam = "Exam"
    case coursework = "Coursework"
    case essay = "Essay"
    case presentation = "Presentation"
    case labWork = "Lab Work"
    case project = "Project"
    case participation = "Participation"
    case quiz = "Quiz"
    case dissertation = "Dissertation"
    
    var icon: String {
        switch self {
        case .exam: return "doc.text"
        case .coursework: return "pencil.and.outline"
        case .essay: return "text.alignleft"
        case .presentation: return "person.3"
        case .labWork: return "flask"
        case .project: return "hammer"
        case .participation: return "hand.raised"
        case .quiz: return "questionmark.circle"
        case .dissertation: return "book.closed"
        
        }
    }
}
