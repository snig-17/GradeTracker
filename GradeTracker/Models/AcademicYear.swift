//
//  AcademicYear.swift
//  GradeTracker
//
//  Created by Snigdha Tiwari  on 26/08/2025.
//

import SwiftData
import Foundation

@Model
class AcademicYear {
    @Attribute(.unique)
    var id: UUID
    var name: String
    var level: Int
    var weightingMultiplier: Double
    var modules: [Module]
    var startDate: Date
    var endDate: Date
    var isActive: Bool
    
    init(id: UUID, name: String, level: Int, weightingMultiplier: Double, modules: [Module], startDate: Date, endDate: Date, isActive: Bool) {
        self.id = id
        self.name = name
        self.level = level
        self.weightingMultiplier = weightingMultiplier
        self.modules = modules
        self.startDate = startDate
        self.endDate = endDate
        self.isActive = isActive
    }
}
