//
//  Module.swift
//  GradeTracker
//
//  Created by Snigdha Tiwari  on 26/08/2025.
//

import Foundation
import SwiftData

@Model
class Module {
    @Attribute(.unique)
    var id: UUID
    var name: String
    var code: String
    var credits: Int
    var term: String
    var lecturer: String
    var isCore: Bool
    var assessments: [Assessment]
    var colour: String
    
    init(
    id: UUID = .init(),
    name: String,
    code: String,
    credits: Int,
    term: String,
    lecturer: String,
    isCore: Bool,
}
