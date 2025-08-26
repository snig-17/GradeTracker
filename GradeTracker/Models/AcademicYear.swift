import SwiftData
import Foundation

@Model
class AcademicYear {
    @Attribute(.unique) var id: UUID
    var name: String
    var level: Int
    var weightingMultiplier: Double
    @Relationship(deleteRule: .cascade) var modules: [Module]
    var startDate: Date
    var endDate: Date
    var isActive: Bool
    
    var yearGPA: Double {
        guard !modules.isEmpty else { return 0.0 }
        let totalCredits = modules.reduce(0) { $0 + $1.credits }
        guard totalCredits > 0 else { return 0.0 }
        
        let totalGradePoints = modules.reduce(0.0) { sum, module in
            return sum + (module.finalGrade * Double(module.credits))
        }
        
        return totalGradePoints / Double(totalCredits)
    }
    
    var completedCredits: Int {
        modules.filter { $0.isCompleted }.reduce(0) { $0 + $1.credits }
    }
    
    var totalCredits: Int {
        modules.reduce(0) { $0 + $1.credits }
    }
    
    init(name: String, level: Int, weightingMultiplier: Double, startDate: Date, endDate: Date) {
        self.id = UUID()
        self.name = name
        self.level = level
        self.weightingMultiplier = weightingMultiplier
        self.modules = []
        self.startDate = startDate
        self.endDate = endDate
        self.isActive = Date() >= startDate && Date() <= endDate
    }
}
