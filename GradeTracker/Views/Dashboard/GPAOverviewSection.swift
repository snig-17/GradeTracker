//
//  GPAOverviewSection.swift
//  GradeTracker
//
//  Created by Snigdha Tiwari  on 26/08/2025.
//

import SwiftUI
import SwiftData

struct GPAOverviewSection: View {
    let student: Student
    
    var body: some View {
        VStack(spacing: 16) {
            // Section Header
            HStack {
                HStack(spacing: 8) {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                        .foregroundStyle(.blue)
                        .font(.headline)
                    
                    Text("Academic Performance")
                        .font(.headline)
                        .fontWeight(.semibold)
                }
                
                Spacer()
                
                Button(action: {
                    // TODO: Navigate to detailed analytics
                }) {
                    Image(systemName: "arrow.up.right")
                        .foregroundStyle(.secondary)
                        .font(.caption)
                }
                .buttonStyle(.plain)
            }
            
            // Main GPA Cards
            HStack(spacing: 12) {
                // Overall Performance Card
                GPACard(
                    title: student.systemType == .uk ? "Overall Grade" : "Overall GPA",
                    value: overallGradeValue,
                    subtitle: student.degreeClassification,
                    color: gradeColor(for: student.overallGPA, system: student.systemType),
                    trend: overallTrend,
                    isMain: true
                )
                
                // Current Year Performance Card
                if let currentYear = student.academicYears.first(where: { $0.isActive }) {
                    GPACard(
                        title: "Current Year",
                        value: currentYearGradeValue(currentYear),
                        subtitle: creditsSubtitle(currentYear),
                        color: gradeColor(for: currentYear.yearGPA, system: student.systemType),
                        trend: currentYearTrend(currentYear),
                        isMain: false
                    )
                }
            }
            
            // Quick Stats Row
            QuickStatsRow(student: student)
            
            // Progress Indicators
            if let currentYear = student.academicYears.first(where: { $0.isActive }) {
                ProgressIndicatorsRow(student: student, currentYear: currentYear)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
    
    // MARK: - Computed Properties
    
    private var overallGradeValue: String {
        if student.systemType == .uk {
            return student.overallGPA > 0 ? String(format: "%.1f%%", student.overallGPA) : "N/A"
        } else {
            return student.overallGPA > 0 ? String(format: "%.2f", student.overallGPA) : "N/A"
        }
    }
    
    private func currentYearGradeValue(_ year: AcademicYear) -> String {
        if student.systemType == .uk {
            return year.yearGPA > 0 ? String(format: "%.1f%%", year.yearGPA) : "N/A"
        } else {
            return year.yearGPA > 0 ? String(format: "%.2f", year.yearGPA) : "N/A"
        }
    }
    
    private func creditsSubtitle(_ year: AcademicYear) -> String {
        "\(year.completedCredits)/\(year.totalCredits) Credits"
    }
    
    private func gradeColor(for grade: Double, system: GradeSystem) -> Color {
        switch system {
        case .uk:
            switch grade {
            case 70...: return .green
            case 60..<70: return .blue
            case 50..<60: return .orange
            case 40..<50: return .red
            default: return .gray
            }
        case .us:
            switch grade {
            case 3.7...: return .green
            case 3.0..<3.7: return .blue
            case 2.5..<3.0: return .orange
            case 2.0..<2.5: return .red
            default: return .gray
            }
        }
    }
    
    private var overallTrend: TrendDirection? {
        // Calculate trend based on year-over-year performance
        let sortedYears = student.academicYears.sorted { $0.startDate < $1.startDate }
        guard sortedYears.count >= 2 else { return nil }
        
        let currentGPA = sortedYears.last?.yearGPA ?? 0
        let previousGPA = sortedYears[sortedYears.count - 2].yearGPA
        
        if currentGPA > previousGPA + 2 { return .up }
        if currentGPA < previousGPA - 2 { return .down }
        return .stable
    }
    
    private func currentYearTrend(_ year: AcademicYear) -> TrendDirection? {
        // Calculate trend based on module performance within the year
        let completedModules = year.modules.filter { $0.currentGrade != nil }
        guard completedModules.count >= 2 else { return nil }
        
        let averageGrade = completedModules.compactMap { $0.currentGrade }.reduce(0.0, +) / Double(completedModules.count)
        let targetGrade = student.systemType == .uk ? 65.0 : 3.0
        
        if averageGrade > targetGrade + 5 { return .up }
        if averageGrade < targetGrade - 5 { return .down }
        return .stable
    }
}

// MARK: - Supporting Views

struct GPACard: View {
    let title: String
    let value: String
    let subtitle: String
    let color: Color
    let trend: TrendDirection?
    let isMain: Bool
    
    private var cardSpacing: CGFloat { isMain ? 12 : 8 }
    private var titleFont: Font { isMain ? .subheadline : .caption }
    private var valueFont: Font { isMain ? .title : .title2 }
    private var subtitleFont: Font { isMain ? .caption : .caption2 }
    private var cardPadding: CGFloat { isMain ? 20 : 16 }
    
    private var cardBackground: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(Color(.systemGray6))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(color.opacity(0.3), lineWidth: isMain ? 2 : 1)
            )
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: cardSpacing) {
            // Title with trend indicator
            HStack {
                Text(title)
                    .font(titleFont)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                
                if let trend = trend {
                    TrendIndicator(direction: trend)
                }
            }
            
            // Main value with animated appearance
            Text(value)
                .font(valueFont)
                .fontWeight(.bold)
                .foregroundStyle(color)
                .contentTransition(.numericText())
                .animation(.easeInOut(duration: 0.3), value: value)
            
            // Subtitle
            Text(subtitle)
                .font(subtitleFont)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .minimumScaleFactor(0.8)
        }
        .frame(maxWidth: .infinity)
        .padding(cardPadding)
        .background(cardBackground)
        .cornerRadius(12)
    }
}

struct TrendIndicator: View {
    let direction: TrendDirection
    
    var body: some View {
        Image(systemName: direction.iconName)
            .font(.caption2)
            .foregroundStyle(direction.color)
            .scaleEffect(0.8)
    }
}

struct QuickStatsRow: View {
    let student: Student
    
    var body: some View {
        HStack(spacing: 16) {
            QuickStatItem(
                title: "Total Credits",
                value: "\(student.totalCredits)",
                icon: "book.stack.fill",
                color: .blue
            )
            
            QuickStatItem(
                title: "Completed",
                value: "\(student.completedCredits)",
                icon: "checkmark.circle.fill",
                color: .green
            )
            
            QuickStatItem(
                title: "Modules",
                value: "\(student.allModules.count)",
                icon: "square.grid.3x3.fill",
                color: .orange
            )
            
            QuickStatItem(
                title: "Year",
                value: currentYearName,
                icon: "calendar.badge.clock",
                color: .purple
            )
        }
    }
    
    private var currentYearName: String {
        if let currentYear = student.currentAcademicYear {
            return currentYear.name
        }
        return "N/A"
    }
}

struct QuickStatItem: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            Circle()
                .fill(color.opacity(0.2))
                .frame(width: 32, height: 32)
                .overlay(
                    Image(systemName: icon)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(color)
                )
            
            Text(value)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(.primary)
            
            Text(title)
                .font(.caption2)
                .foregroundStyle(.secondary)
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity)
    }
}

struct ProgressIndicatorsRow: View {
    let student: Student
    let currentYear: AcademicYear
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Progress")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(.secondary)
                Spacer()
            }
            
            VStack(spacing: 8) {
                // Credits Progress
                ProgressBar(
                    title: "Credits Progress",
                    current: currentYear.completedCredits,
                    total: currentYear.totalCredits,
                    color: .blue,
                    suffix: "credits"
                )
                
                // Modules Progress
                ProgressBar(
                    title: "Modules Completed",
                    current: currentYear.completedModules,
                    total: currentYear.modules.count,
                    color: .green,
                    suffix: "modules"
                )
            }
        }
    }
}

struct ProgressBar: View {
    let title: String
    let current: Int
    let total: Int
    let color: Color
    let suffix: String
    
    private var progress: Double {
        guard total > 0 else { return 0 }
        return Double(current) / Double(total)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(title)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                Spacer()
                
                Text("\(current)/\(total) \(suffix)")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundStyle(.primary)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color(.systemGray5))
                        .frame(height: 6)
                        .cornerRadius(3)
                    
                    Rectangle()
                        .fill(color)
                        .frame(width: geometry.size.width * progress, height: 6)
                        .cornerRadius(3)
                        .animation(.easeInOut(duration: 0.5), value: progress)
                }
            }
            .frame(height: 6)
        }
    }
}

// MARK: - Supporting Types

enum TrendDirection {
    case up, down, stable
    
    var iconName: String {
        switch self {
        case .up: return "arrow.up.right"
        case .down: return "arrow.down.right"
        case .stable: return "minus"
        }
    }
    
    var color: Color {
        switch self {
        case .up: return .green
        case .down: return .red
        case .stable: return .gray
        }
    }
}
