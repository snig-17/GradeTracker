import SwiftData
import Foundation

@Model
class Module {
    @Attribute(.unique) var id: UUID
    var name: String
    var code: String
    var credits: Int
    var semester: String
    var lecturer: String
    var isCore: Bool
    @Relationship(deleteRule: .cascade) var assessments: [Assessment]
    var color: String
    
    var finalGrade: Double {
        let totalWeighting = assessments.reduce(0.0) { $0 + $1.weighting }
        guard totalWeighting > 0 else { return 0.0 }
        
        return assessments.reduce(0.0) { sum, assessment in
            guard assessment.isCompleted else { return sum }
            return sum + (assessment.percentage * assessment.weighting / 100.0)
        }
    }
    
    var isCompleted: Bool {
        !assessments.isEmpty && assessments.allSatisfy { $0.isCompleted }
    }
    
    var completionPercentage: Double {
        let totalWeighting = assessments.reduce(0.0) { $0 + $1.weighting }
        let completedWeighting = assessments.filter { $0.isCompleted }.reduce(0.0) { $0 + $1.weighting }
        return totalWeighting > 0 ? completedWeighting / totalWeighting : 0.0
    }
    
    init(name: String, code: String, credits: Int, semester: String, lecturer: String = "", isCore: Bool = true) {
        self.id = UUID()
        self.name = name
        self.code = code
        self.credits = credits
        self.semester = semester
        self.lecturer = lecturer
        self.isCore = isCore
        self.assessments = []
        self.color = "blue"
    }
}
