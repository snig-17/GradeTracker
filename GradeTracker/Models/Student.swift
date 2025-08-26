//
//  Student.swift
//  GradeTracker
//
//  Created by Snigdha Tiwari  on 26/08/2025.
//

import Foundation
import SwiftData

@Model
class Student {
    @Attribute(.unique)
    var id: UUID
    var studentNumber: String
    var university: String
    var course: String
    var systemType: GradingSystem
    var startYear: Int
    var expectedGraduation: Int
    var academicYears: [AcademicYear]
    var createdDate: Date
    
    // MARK: - computed properties
    
    var overallAverage: Double {
        let validYears = academicYears.filter { $0.weightingMultiplier > 0 }
        guard !validYears.isEmpty else {
            return 0.0
        }
        let totalWeightedGrades = validYears.reduce(0.0) { sum, year in
            return sum + (year.yearAverage * year.weightingMultiplier)
        }
        let totalWeighting = validYears.reduce(0.0) {$0 + $1.weightingMultiplier}
        
        return totalWeighting > 0 ? totalWeightedGrades / totalWeighting : 0.0
    }
    
    var degreeClassification: String {
        switch systemType {
        case .uk:
            return UKGradeCalculator.getClassification(from: overallAverage
        case .us:
            return USGradeCalculator.getGPALetter(from: overallAverage)
    }
}
    
    init(id: UUID, studentNumber: String, university: String, course: String, systemType: GradingSystem, startYear: Int, expectedGraduation: Int, academicYears: [AcademicYear], createdDate: Date) {
        self.id = id
        self.studentNumber = studentNumber
        self.university = university
        self.course = course
        self.systemType = systemType
        self.startYear = startYear
        self.expectedGraduation = expectedGraduation
        self.academicYears = academicYears
        self.createdDate = createdDate
    }
}

enum GradingSystem: String, CaseIterable, Codable {
    case uk = "UK System"
    case us = "US System"
    
    var displayName: String {
        rawValue
    }
}
