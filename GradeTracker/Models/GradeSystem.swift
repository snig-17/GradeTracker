//
//  GradeSystem.swift
//  GradeTracker
//
//  Created by Snigdha Tiwari on 27/08/2025.
//

import Foundation

enum GradeSystem: String, CaseIterable, Codable {
    case uk = "UK System"
    case us = "US System"
    
    var displayName: String {
        return rawValue
    }
}
