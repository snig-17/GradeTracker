//
//  GradeCalculator.swift
//  GradeTracker
//
//  Created by Snigdha Tiwari  on 26/08/2025.
//

import Foundation

struct UKGradeCalculator {
    static func getClassification(from percentage: Double) -> String {
        switch percentage {
        case 70...:
            return "First Class Honours (1st)"
        case 60..<70:
            return "Upper Second Class (2:1)"
        case 50..<60:
            return "Lower Second Class (2:2)"
        case 40..<50:
            return "Third Class Honours (3rd)"
        default:
            return "Fail"
        }
    }
    
    static func getGradePoints(from percentage: Double) -> Double {
        switch percentage {
        case 70...:
            return 4.0
        case 60..<70:
            return 3.0
        case 50..<60:
            return 2.0
        case 40..<50:
            return 1.0
        default:
            return 0.0
        }
    }
    
    static func getShortClassification(from percentage: Double) -> String {
        switch percentage {
        case 70...:
            return "1st"
        case 60..<70:
            return "2:1"
        case 50..<60:
            return "2:2"
        case 40..<50:
            return "3rd"
        default:
            return "Fail"
        }
    }
    
    static func getLetterGrade(from percentage: Double) -> String {
        switch percentage {
        case 85...:
            return "A*"
        case 70..<85:
            return "A"
        case 60..<70:
            return "B"
        case 50..<60:
            return "C"
        case 40..<50:
            return "D"
        default:
            return "F"
        }
    }
}

struct USGradeCalculator {
    static func getGPALetter(from gpa: Double) -> String {
        switch gpa {
        case 3.97...:
            return "A+"
        case 3.67..<3.97:
            return "A"
        case 3.33..<3.67:
            return "A-"
        case 3.0..<3.33:
            return "B+"
        case 2.67..<3.0:
            return "B"
        case 2.33..<2.67:
            return "B-"
        case 2.0..<2.33:
            return "C+"
        case 1.67..<2.0:
            return "C"
        case 1.33..<1.67:
            return "C-"
        case 1.0..<1.33:
            return "D+"
        case 0.67..<1.0:
            return "D"
        case 0.0..<0.67:
            return "D-"
        default:
            return "F"
        }
    }
    
    static func getGradePoints(from percentage: Double) -> Double {
        switch percentage {
        case 97...:
            return 4.0
        case 93..<97:
            return 3.7
        case 90..<93:
            return 3.3
        case 87..<90:
            return 3.0
        case 83..<87:
            return 2.7
        case 80..<83:
            return 2.3
        case 77..<80:
            return 2.0
        case 73..<77:
            return 1.7
        case 70..<73:
            return 1.3
        case 67..<70:
            return 1.0
        case 65..<67:
            return 0.7
        default:
            return 0.0
        }
    }
    
    static func percentageFromGPA(_ gpa: Double) -> Double {
        switch gpa {
        case 3.97...:
            return 98
        case 3.67..<3.97:
            return 95
        case 3.33..<3.67:
            return 91
        case 3.0..<3.33:
            return 88
        case 2.67..<3.0:
            return 85
        case 2.33..<2.67:
            return 82
        case 2.0..<2.33:
            return 78
        case 1.67..<2.0:
            return 75
        case 1.33..<1.67:
            return 72
        case 1.0..<1.33:
            return 68
        case 0.67..<1.0:
            return 66
        case 0.0..<0.67:
            return 63
        default:
            return 0
        }
    }
}

struct GradeConverter {
    static func percentageToLetter(percentage: Double, system: GradingSystem) -> String {
        switch system {
        case .uk:
            return UKGradeCalculator.getShortClassification(from: percentage)
        case .us:
            let gpa = USGradeCalculator.getGradePoints(from: percentage)
            return USGradeCalculator.getGPALetter(from: gpa)
        }
    }
    
    static func percentageToGPA(percentage: Double, system: GradingSystem) -> Double {
        switch system {
        case .uk:
            return UKGradeCalculator.getGradePoints(from: percentage)
        case .us:
            return USGradeCalculator.getGradePoints(from: percentage)
        }
    }
    
    static func normalizeGrade(grade: Double, fromSystem: GradingSystem, toSystem: GradingSystem) -> Double {
        if fromSystem == toSystem {
            return grade
        }
        
        switch (fromSystem, toSystem) {
        case (.uk, .us):
            return UKGradeCalculator.getGradePoints(from: grade)
        case (.us, .uk):
            return USGradeCalculator.percentageFromGPA(grade)
        default:
            return grade
        }
    }
}

struct GradeStatistics {
    static func calculateWeightedAverage(grades: [(grade: Double, weight: Double)]) -> Double {
        let totalWeight = grades.reduce(0) { $0 + $1.weight }
        guard totalWeight > 0 else { return 0 }
        
        let weightedSum = grades.reduce(0) { sum, item in
            sum + (item.grade * item.weight)
        }
        
        return weightedSum / totalWeight
    }
    
    static func predictFinalGrade(
        currentGrades: [(grade: Double, weight: Double)],
        remainingWeight: Double,
        targetGrade: Double
    ) -> Double? {
        let currentWeightedSum = currentGrades.reduce(0) { sum, item in
            sum + (item.grade * item.weight)
        }
        
        let totalCurrentWeight = currentGrades.reduce(0) { $0 + $1.weight }
        let totalWeight = totalCurrentWeight + remainingWeight
        
        guard remainingWeight > 0 && totalWeight > 0 else { return nil }
        
        let requiredWeightedSum = targetGrade * totalWeight
        let remainingWeightedSum = requiredWeightedSum - currentWeightedSum
        
        return remainingWeightedSum / remainingWeight
    }
    
    static func getGradeDistribution(grades: [Double]) -> [String: Int] {
        var distribution: [String: Int] = [:]
        
        for grade in grades {
            let bracket = getGradeBracket(grade)
            distribution[bracket, default: 0] += 1
        }
        
        return distribution
    }
    
    private static func getGradeBracket(_ grade: Double) -> String {
        switch grade {
        case 90...:
            return "90-100%"
        case 80..<90:
            return "80-89%"
        case 70..<80:
            return "70-79%"
        case 60..<70:
            return "60-69%"
        case 50..<60:
            return "50-59%"
        case 40..<50:
            return "40-49%"
        default:
            return "Below 40%"
        }
    }
}
