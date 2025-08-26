import SwiftData
import Foundation

@Model
class Assessment {
    @Attribute(.unique) var id: UUID
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
    
    var isOverdue: Bool {
        guard let dueDate = dueDate else { return false }
        return !isCompleted && Date() > dueDate
    }
    
    var daysUntilDue: Int? {
        guard let dueDate = dueDate else { return nil }
        return Calendar.current.dateComponents([.day], from: Date(), to: dueDate).day
    }
    
    init(name: String, type: AssessmentType, weighting: Double, dueDate: Date? = nil) {
        self.id = UUID()
        self.name = name
        self.type = type
        self.weighting = weighting
        self.percentage = 0.0
        self.maxMarks = 100.0
        self.achievedMarks = 0.0
        self.dueDate = dueDate
        self.isCompleted = false
        self.feedback = ""
        self.notes = ""
    }
}

enum AssessmentType: String, CaseIterable, Codable {
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
