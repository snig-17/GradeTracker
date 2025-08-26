//
//  GPAOverviewSection.swift
//  GradeTracker
//
//  Created by Snigdha Tiwari  on 26/08/2025.
//

import SwiftUI

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
        .background(Color.cardBackground)
        .cornerRadius(16)
        .shadow(color: Color.cardShadow, radius: 8, x: 0, y: 4)
    }
    
    // MARK: - Computed Properties
    
    private var overallGradeValue: String {
        if student.systemType == .uk {
            return student.overallGPA > 0 ? "\(student.overallGPA.rounded(to: 1))%" : "N/A"
        } else {
            return student.overallGPA > 0 ? student.overallGPA.gpaString : "N/A"
        }
    }
    
    private func currentYearGradeValue(_ year: AcademicYear) -> String {
        if student.systemType == .uk {
            return year.yearGPA > 0 ? "\(year.yearGPA.rounded(to: 1))%" : "N/A"
        } else {
            return year.yearGPA > 0 ? year.yearGPA.gpaString : "N/A"
        }
    }
    
    private func creditsSubtitle(_ year: AcademicYear) -> String {
        "\(year.completedCredits)/\(year.totalCredits) Credits"
    }
    
    private func gradeColor(for grade: Double, system: GradingSystem) -> Color {
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
        let completedModules = year.modules.filter { $0.finalGrade > 0 }
        guard completedModules.count >= 2 else { return nil }
        
        let averageGrade = completedModules.reduce(0.0) { $0 + $1.finalGrade } / Double(completedModules.count)
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
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(color.opacity(0.3), lineWidth: isMain ? 2 : 1)
        )
    }
    
    // MARK: - Computed Properties
    
    private var cardSpacing: CGFloat {
        isMain ? 10 : 8
    }
    
    private var titleFont: Font {
        isMain ? .caption : .caption2
    }
    
    private var valueFont: Font {
        isMain ? .title : .title2
    }
    
    private var subtitleFont: Font {
        isMain ? .caption : .caption2
    }
    
    private var cardPadding: CGFloat {
        isMain ? 16 : 12
    }
    
    private var cardBackground: some View {
        Group {
            if isMain {
                LinearGradient(
                    colors: [color.opacity(0.15), color.opacity(0.05)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            } else {
                color.opacity(0.1)
            }
        }
    }
}

enum TrendDirection {
    case up, down, stable
    
    var icon: String {
        switch self {
        case .up: return "arrow.up"
        case .down: return "arrow.down"
        case .stable: return "minus"
        }
    }
    
    var color: Color {
        switch self {
        case .up: return .green
        case .down: return .red
        case .stable: return .secondary
        }
    }
}

struct TrendIndicator: View {
    let direction: TrendDirection
    
    var body: some View {
        Image(systemName: direction.icon)
            .font(.caption2)
            .foregroundStyle(direction.color)
            .padding(4)
            .background(direction.color.opacity(0.1))
            .cornerRadius(4)
    }
}

struct QuickStatsRow: View {
    let student: Student
    
    var body: some View {
        HStack(spacing: 20) {
            QuickStatItem(
                icon: "books.vertical",
                value: "\(totalModules)",
                label: "Modules",
                color: .blue
            )
            
            QuickStatItem(
                icon: "doc.text",
                value: "\(pendingAssessments)",
                label: "Pending",
                color: .orange
            )
            
            QuickStatItem(
                icon: "calendar",
                value: daysToNextDeadline != nil ? "\(daysToNextDeadline!)" : "None",
                label: "Days Left",
                color: daysToNextDeadline != nil && daysToNextDeadline! <= 3 ? .red : .green
            )
            
            QuickStatItem(
                icon: "percent",
                value: "\(Int(completionPercentage))",
                label: "Complete",
                color: .purple
            )
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(.secondary.opacity(0.05))
        .cornerRadius(10)
    }
    
    private var totalModules: Int {
        student.academicYears.flatMap { $0.modules }.count
    }
    
    private var pendingAssessments: Int {
        student.academicYears
            .flatMap { $0.modules }
            .flatMap { $0.assessments }
            .filter { !$0.isCompleted }
            .count
    }
    
    private var daysToNextDeadline: Int? {
        let upcomingAssessments = student.academicYears
            .flatMap { $0.modules }
            .flatMap { $0.assessments }
            .filter { !$0.isCompleted && $0.dueDate != nil }
            .sorted { ($0.dueDate ?? Date.distantFuture) < ($1.dueDate ?? Date.distantFuture) }
        
        return upcomingAssessments.first?.daysUntilDue
    }
    
    private var completionPercentage: Double {
        let allAssessments = student.academicYears
            .flatMap { $0.modules }
            .flatMap { $0.assessments }
        
        guard !allAssessments.isEmpty else { return 0 }
        
        let completedCount = allAssessments.filter { $0.isCompleted }.count
        return Double(completedCount) / Double(allAssessments.count) * 100
    }
}

struct QuickStatItem: View {
    let icon: String
    let value: String
    let label: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.caption)
                .foregroundStyle(color)
            
            Text(value)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundStyle(.primary)
            
            Text(label)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

struct ProgressIndicatorsRow: View {
    let student: Student
    let currentYear: AcademicYear
    
    var body: some View {
        VStack(spacing: 12) {
            // Section title
            HStack {
                Text("Year Progress")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(.secondary)
                
                Spacer()
                
                Text("\(Int(yearProgress * 100))% Complete")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundStyle(.blue)
            }
            
            // Progress bars
            VStack(spacing: 8) {
                // Credits progress
                ProgressBar(
                    title: "Credits",
                    current: currentYear.completedCredits,
                    total: currentYear.totalCredits,
                    color: .blue,
                    suffix: "credits"
                )
                
                // Grade target progress
                if student.systemType == .uk {
                    ProgressBar(
                        title: "Target (65%)",
                        current: Int(min(currentYear.yearGPA, 65)),
                        total: 65,
                        color: currentYear.yearGPA >= 65 ? .green : .orange,
                        suffix: "%"
                    )
                } else {
                    ProgressBar(
                        title: "Target (3.0)",
                        current: Int(min(currentYear.yearGPA * 100 / 4, 75)), // Convert to percentage
                        total: 75,
                        color: currentYear.yearGPA >= 3.0 ? .green : .orange,
                        suffix: "/4.0"
                    )
                }
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(.secondary.opacity(0.05))
        .cornerRadius(10)
    }
    
    private var yearProgress: Double {
        let totalCredits = currentYear.totalCredits
        let completedCredits = currentYear.completedCredits
        return totalCredits > 0 ? Double(completedCredits) / Double(totalCredits) : 0
    }
}

struct ProgressBar: View {
    let title: String
    let current: Int
    let total: Int
    let color: Color
    let suffix: String
    
    private var progress: Double {
        total > 0 ? Double(current) / Double(total) : 0
    }
    
    var body: some View {
        HStack {
            Text(title)
                .font(.caption2)
                .foregroundStyle(.secondary)
                .frame(width: 60, alignment: .leading)
            
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(.secondary.opacity(0.2))
                    .frame(height: 6)
                
                RoundedRectangle(cornerRadius: 4)
                    .fill(color)
                    .frame(width: max(0, progress * 120), height: 6)
                    .animation(.easeInOut(duration: 0.5), value: progress)
            }
            .frame(width: 120)
            
            Text("\(current)/\(total) \(suffix)")
                .font(.caption2)
                .foregroundStyle(.secondary)
                .frame(minWidth: 60, alignment: .trailing)
        }
    }
}

#Preview {
    GPAOverviewSection(student: Student.sampleStudent)
        .padding()
        .background(Color(.systemGroupedBackground))
}

