//
//  Extensions.swift
//  GradeTracker
//
//  Created by Snigdha Tiwari on 27/08/2025.
//

import SwiftUI
import Foundation

// MARK: - Color Extensions
extension Color {
    /// Initialize a Color from a hex string
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
    
    /// Convert Color to hex string
    func toHex() -> String? {
        let uic = UIColor(self)
        guard let components = uic.cgColor.components, components.count >= 3 else {
            return nil
        }
        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        return String(format: "#%02lX%02lX%02lX",
                     lroundf(r * 255),
                     lroundf(g * 255),
                     lroundf(b * 255))
    }
    
    // App-specific color constants
    static let appPrimary = Color(hex: "#007AFF")
    static let appSecondary = Color(hex: "#34C759")
    static let appBackground = Color(.systemGray6)
    static let appCardBackground = Color(.systemBackground)
    static let appAccent = Color(hex: "#FF9500")
    static let appSuccess = Color(hex: "#34C759")
    static let appWarning = Color(hex: "#FF9500")
    static let appError = Color(hex: "#FF3B30")
}

// MARK: - Double Extensions
extension Double {
    /// Format as percentage string
    var asPercentage: String {
        return String(format: "%.1f%%", self)
    }
    
    /// Format as GPA string
    var asGPA: String {
        return String(format: "%.2f", self)
    }
    
    /// Round to specified decimal places
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
    
    /// Check if grade is passing (40% for UK, 60% for US)
    func isPassing(for system: GradeSystem) -> Bool {
        switch system {
        case .uk:
            return self >= 40.0
        case .us:
            return self >= 60.0
        }
    }
}

// MARK: - Date Extensions
extension Date {
    /// Format date as "MMM dd, yyyy"
    var formatted: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: self)
    }
    
    /// Format date as "MMM dd"
    var shortFormatted: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd"
        return formatter.string(from: self)
    }
    
    /// Check if date is today
    var isToday: Bool {
        return Calendar.current.isDateInToday(self)
    }
    
    /// Check if date is tomorrow
    var isTomorrow: Bool {
        return Calendar.current.isDateInTomorrow(self)
    }
    
    /// Check if date is in the past
    var isPast: Bool {
        return self < Date()
    }
    
    /// Check if date is within next 7 days
    var isWithinWeek: Bool {
        let weekFromNow = Calendar.current.date(byAdding: .day, value: 7, to: Date()) ?? Date()
        return self <= weekFromNow && self >= Date()
    }
    
    /// Days until this date
    var daysUntil: Int {
        let calendar = Calendar.current
        let startOfToday = calendar.startOfDay(for: Date())
        let startOfTargetDay = calendar.startOfDay(for: self)
        let components = calendar.dateComponents([.day], from: startOfToday, to: startOfTargetDay)
        return components.day ?? 0
    }
    
    /// Relative time string (e.g., "Due in 3 days", "Overdue by 2 days")
    var relativeTimeString: String {
        let days = daysUntil
        if days > 0 {
            return days == 1 ? "Due tomorrow" : "Due in \(days) days"
        } else if days == 0 {
            return "Due today"
        } else {
            let overdueDays = abs(days)
            return overdueDays == 1 ? "Overdue by 1 day" : "Overdue by \(overdueDays) days"
        }
    }
}

// MARK: - String Extensions
extension String {
    /// Capitalize first letter only
    var capitalizedFirst: String {
        return prefix(1).capitalized + dropFirst()
    }
    
    /// Remove whitespace and newlines
    var trimmed: String {
        return trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    /// Check if string is empty or whitespace only
    var isBlankOrEmpty: Bool {
        return trimmed.isEmpty
    }
    
    /// Convert to URL if valid
    var asURL: URL? {
        return URL(string: self)
    }
}

// MARK: - Array Extensions
extension Array where Element == Assessment {
    /// Filter completed assessments
    var completed: [Assessment] {
        return filter { $0.isCompleted }
    }
    
    /// Filter pending assessments
    var pending: [Assessment] {
        return filter { !$0.isCompleted }
    }
    
    /// Filter overdue assessments
    var overdue: [Assessment] {
        return filter { !$0.isCompleted && $0.dueDate < Date() }
    }
    
    /// Filter upcoming assessments (within next 7 days)
    var upcoming: [Assessment] {
        return filter { !$0.isCompleted && $0.dueDate.isWithinWeek }
    }
    
    /// Sort by due date
    var sortedByDueDate: [Assessment] {
        return sorted { $0.dueDate < $1.dueDate }
    }
    
    /// Total weighting of assessments
    var totalWeighting: Double {
        return reduce(0) { $0 + $1.weighting }
    }
}

extension Array where Element == Module {
    /// Filter completed modules
    var completed: [Module] {
        return filter { $0.isCompleted }
    }
    
    /// Filter active modules
    var active: [Module] {
        return filter { !$0.isCompleted }
    }
    
    /// Total credits
    var totalCredits: Int {
        return reduce(0) { $0 + $1.credits }
    }
    
    /// Modules with grades
    var withGrades: [Module] {
        return filter { $0.currentGrade != nil }
    }
    
    /// Average grade across all modules (credit-weighted)
    var averageGrade: Double? {
        let modulesWithGrades = withGrades
        guard !modulesWithGrades.isEmpty else { return nil }
        
        let totalCredits = modulesWithGrades.totalCredits
        guard totalCredits > 0 else { return nil }
        
        let weightedSum = modulesWithGrades.compactMap { module -> Double? in
            guard let grade = module.currentGrade else { return nil }
            return grade * Double(module.credits)
        }.reduce(0, +)
        
        return weightedSum / Double(totalCredits)
    }
}

// MARK: - CGFloat Extensions
extension CGFloat {
    // App-specific spacing constants
    static let appSmallSpacing: CGFloat = 8
    static let appMediumSpacing: CGFloat = 16
    static let appLargeSpacing: CGFloat = 24
    static let appExtraLargeSpacing: CGFloat = 32
    
    // App-specific corner radius constants
    static let appSmallRadius: CGFloat = 8
    static let appMediumRadius: CGFloat = 12
    static let appLargeRadius: CGFloat = 16
    static let appExtraLargeRadius: CGFloat = 24
    
    // App-specific padding constants
    static let appSmallPadding: CGFloat = 8
    static let appMediumPadding: CGFloat = 16
    static let appLargePadding: CGFloat = 24
}

// MARK: - View Extensions
extension View {
    /// Apply card styling
    func cardStyle() -> some View {
        self
            .background(Color.appCardBackground)
            .cornerRadius(.appMediumRadius)
            .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
    
    /// Apply primary button styling
    func primaryButtonStyle() -> some View {
        self
            .foregroundColor(.white)
            .padding()
            .background(Color.appPrimary)
            .cornerRadius(.appSmallRadius)
    }
    
    /// Apply secondary button styling
    func secondaryButtonStyle() -> some View {
        self
            .foregroundColor(Color.appPrimary)
            .padding()
            .background(Color.appPrimary.opacity(0.1))
            .cornerRadius(.appSmallRadius)
    }
    
    /// Hide view conditionally
    @ViewBuilder func hidden(_ shouldHide: Bool) -> some View {
        if shouldHide {
            self.hidden()
        } else {
            self
        }
    }
    
    /// Apply conditional modifier
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}
