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
