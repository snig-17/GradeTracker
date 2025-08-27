//
//  Constants.swift
//  GradeTracker
//
//  Created by Snigdha Tiwari on 27/08/2025.
//

import SwiftUI
import Foundation

// MARK: - App Constants

struct AppConstants {
    // MARK: - Default Values
    static let defaultCredits = 20
    static let defaultSemester = "Semester 1"
    static let defaultAcademicYear = "2024-25"
    
    // MARK: - Credit Options
    static let creditOptions = [10, 15, 20, 30, 40, 60]
    
    // MARK: - Semester Options
    static let semesterOptions = [
        "Semester 1",
        "Semester 2", 
        "Summer Term",
        "Year Long"
    ]
    
    // MARK: - Grade Thresholds (UK System)
    struct UKGrades {
        static let firstClass: Double = 70.0
        static let upperSecond: Double = 60.0
        static let lowerSecond: Double = 50.0
        static let third: Double = 40.0
    }
    
    // MARK: - Grade Thresholds (US System)
    struct USGrades {
        static let aPlus: Double = 97.0
        static let a: Double = 93.0
        static let aMinus: Double = 90.0
        static let bPlus: Double = 87.0
        static let b: Double = 83.0
        static let bMinus: Double = 80.0
        static let c: Double = 70.0
        static let d: Double = 60.0
    }
    
    // MARK: - App Colors (Hex Values)
    struct AppColors {
        static let primary = "#007AFF"
        static let secondary = "#34C759"
        static let accent = "#FF9500"
        static let success = "#34C759"
        static let warning = "#FF9500" 
        static let error = "#FF3B30"
        static let purple = "#AF52DE"
        static let teal = "#5AC8FA"
        static let pink = "#FF2D92"
        static let indigo = "#5856D6"
    }
    
    // MARK: - Default Module Colors
    static let defaultModuleColors = [
        AppColors.primary,
        AppColors.secondary,
        AppColors.accent,
        AppColors.purple,
        AppColors.teal,
        AppColors.pink,
        AppColors.indigo,
        AppColors.error
    ]
    
    // MARK: - Animation Constants
    struct Animation {
        static let defaultDuration: Double = 0.3
        static let slowDuration: Double = 0.5
        static let fastDuration: Double = 0.15
    }
    
    // MARK: - Layout Constants
    struct Layout {
        static let cornerRadius: CGFloat = 12
        static let smallCornerRadius: CGFloat = 8
        static let largeCornerRadius: CGFloat = 16
        
        static let padding: CGFloat = 16
        static let smallPadding: CGFloat = 8
        static let largePadding: CGFloat = 24
        
        static let spacing: CGFloat = 12
        static let smallSpacing: CGFloat = 6
        static let largeSpacing: CGFloat = 20
    }
    
    // MARK: - Chart Constants
    struct Chart {
        static let defaultHeight: CGFloat = 200
        static let compactHeight: CGFloat = 120
    }
    
    // MARK: - Validation Constants
    struct Validation {
        static let maxModuleNameLength = 100
        static let maxModuleCodeLength = 10
        static let maxLecturerNameLength = 50
        static let maxAssessmentTitleLength = 100
        static let maxNotesLength = 500
    }
}
