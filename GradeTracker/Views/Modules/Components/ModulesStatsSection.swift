//
//  ModulesStatsSection.swift
//  GradeTracker
//
//  Created by Snigdha Tiwari  on 26/08/2025.
//

// Views/Modules/Components/ModuleStatsSection.swift
import SwiftUI

struct ModuleStatsSection: View {
    let modules: [Module]
    
    private var completedModules: Int {
        modules.filter { $0.isCompleted }.count
    }
    
    private var inProgressModules: Int {
        modules.filter { !$0.isCompleted }.count
    }
    
    private var totalCredits: Int {
        modules.reduce(0) { $0 + $1.credits }
    }
    
    private var completedCredits: Int {
        modules.filter { $0.isCompleted }.reduce(0) { $0 + $1.credits }
    }
    
    private var averageGrade: Double? {
        let gradesWithWeights = modules.compactMap { module -> (Double, Int)? in
            guard let grade = module.currentGrade else { return nil }
            return (grade, module.credits)
        }
        
        guard !gradesWithWeights.isEmpty else { return nil }
        
        let totalWeightedGrade = gradesWithWeights.reduce(0.0) { $0 + ($1.0 * Double($1.1)) }
        let totalWeight = gradesWithWeights.reduce(0) { $0 + $1.1 }
        
        return totalWeightedGrade / Double(totalWeight)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Overview")
                .font(.headline)
                .fontWeight(.bold)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                StatsCard(
                    title: "Total Modules",
                    value: "\(modules.count)",
                    subtitle: "\(completedModules) completed",
                    icon: "book.stack.fill",
                    color: .blue
                )
                
                StatsCard(
                    title: "Credits",
                    value: "\(totalCredits)",
                    subtitle: "\(completedCredits) earned",
                    icon: "graduationcap.fill",
                    color: .green
                )
                
                StatsCard(
                    title: "In Progress",
                    value: "\(inProgressModules)",
                    subtitle: "Active modules",
                    icon: "clock.fill",
                    color: .orange
                )
                
                if let avgGrade = averageGrade {
                    StatsCard(
                        title: "Average Grade",
                        value: String(format: "%.1f%%", avgGrade),
                        subtitle: getGradeBand(for: avgGrade),
                        icon: "chart.line.uptrend.xyaxis",
                        color: .purple
                    )
                } else {
                    StatsCard(
                        title: "Average Grade",
                        value: "N/A",
                        subtitle: "No grades yet",
                        icon: "chart.line.uptrend.xyaxis",
                        color: .gray
                    )
                }
            }
        }
    }
    
    private func getGradeBand(for grade: Double) -> String {
        // Assuming UK system for simplicity
        if grade >= 70 { return "First Class" }
        else if grade >= 60 { return "Upper Second" }
        else if grade >= 50 { return "Lower Second" }
        else if grade >= 40 { return "Third Class" }
        else { return "Below Pass" }
    }
}

struct StatsCard: View {
    let title: String
    let value: String
    let subtitle: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Circle()
                    .fill(color.opacity(0.2))
                    .frame(width: 32, height: 32)
                    .overlay(
                        Image(systemName: icon)
                            .foregroundColor(color)
                            .font(.system(size: 14, weight: .semibold))
                    )
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 2) {
                    Text(value)
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.trailing)
                }
            }
            
            HStack {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
                Spacer()
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(color.opacity(0.1), lineWidth: 1)
        )
    }
}

