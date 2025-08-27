//
//  ModulesStatsSection.swift
//  GradeTracker
//
//  Created by Snigdha Tiwari  on 26/08/2025.
//

import SwiftUI

struct ModuleStatsSection: View {
    let student: Student
    let filteredModules: [Module]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                // Total Modules
                StatCard(
                    title: "Total Modules",
                    value: "\(filteredModules.count)",
                    subtitle: "Active",
                    color: .blue,
                    icon: "books.vertical"
                )
                
                // Average Grade
                StatCard(
                    title: student.systemType == .uk ? "Average %" : "Average GPA",
                    value: averageGradeString,
                    subtitle: averageGradeClassification,
                    color: averageGradeColor,
                    icon: "chart.bar"
                )
                
                // Completed Modules
                StatCard(
                    title: "Completed",
                    value: "\(completedModules)",
                    subtitle: "\(Int(completionPercentage))%",
                    color: .green,
                    icon: "checkmark.circle"
                )
                
                // Total Credits
                StatCard(
                    title: "Credits",
                    value: "\(totalCredits)",
                    subtitle: "Total",
                    color: .purple,
                    icon: "star"
                )
            }
            .padding(.horizontal, 1)
        }
    }
    
    // MARK: - Computed Properties
    
    private var averageGrade: Double {
        guard !filteredModules.isEmpty else { return 0 }
        let totalGrade = filteredModules.reduce(0.0) { $0 + $1.finalGrade }
        return totalGrade / Double(filteredModules.count)
    }
    
    private var averageGradeString: String {
        if student.systemType == .uk {
            return "\(averageGrade.rounded(to: 1))%"
        } else {
            let gpa = USGradeCalculator.getGradePoints(from: averageGrade)
            return gpa.gpaString
        }
    }
    
    private var averageGradeClassification: String {
        if student.systemType == .uk {
            return UKGradeCalculator.getShortClassification(from: averageGrade)
        } else {
            let gpa = USGradeCalculator.getGradePoints(from: averageGrade)
            return USGradeCalculator.getGPALetter(from: gpa)
        }
    }
    
    private var averageGradeColor: Color {
        if student.systemType == .uk {
            switch averageGrade {
            case 70...: return .green
            case 60..<70: return .blue
            case 50..<60: return .orange
            case 40..<50: return .red
            default: return .gray
            }
        } else {
            let gpa = USGradeCalculator.getGradePoints(from: averageGrade)
            switch gpa {
            case 3.5...: return .green
            case 3.0..<3.5: return .blue
            case 2.5..<3.0: return .orange
            case 2.0..<2.5: return .red
            default: return .gray
            }
        }
    }
    
    private var completedModules: Int {
        filteredModules.filter { $0.isCompleted }.count
    }
    
    private var completionPercentage: Double {
        guard !filteredModules.isEmpty else { return 0 }
        return Double(completedModules) / Double(filteredModules.count) * 100
    }
    
    private var totalCredits: Int {
        filteredModules.reduce(0) { $0 + $1.credits }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let subtitle: String
    let color: Color
    let icon: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundStyle(color)
                    .font(.headline)
                
                Spacer()
                
                Text(value)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(color)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundStyle(.primary)
                
                Text(subtitle)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .frame(width: 120, height: 80)
        .background(color.opacity(0.1))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(color.opacity(0.3), lineWidth: 1)
        )
    }
}

#Preview {
    ModuleStatsSection(
        student: Student.sampleStudent,
        filteredModules: Student.sampleStudent.academicYears.first?.modules ?? []
    )
    .padding()
}

