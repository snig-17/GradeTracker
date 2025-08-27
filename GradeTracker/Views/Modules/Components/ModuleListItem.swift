//
//  ModuleListItem.swift
//  GradeTracker
//
//  Created by Snigdha Tiwari  on 26/08/2025.
//

import SwiftUI

struct ModuleListItem: View {
    let module: Module
    let systemType: GradingSystem
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 0) {
                // Main Content
                HStack(spacing: 12) {
                    // Color indicator and module info
                    VStack(alignment: .leading, spacing: 8) {
                        // Header row
                        HStack {
                            Text(module.code)
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundStyle(Color.moduleColor(for: module.color))
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.moduleColor(for: module.color).opacity(0.15))
                                .cornerRadius(6)
                            
                            Spacer()
                            
                            HStack(spacing: 4) {
                                Text("\(module.credits)")
                                    .font(.caption)
                                    .fontWeight(.medium)
                                
                                Text("credits")
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                            }
                            
                            if module.isCore {
                                Image(systemName: "star.fill")
                                    .font(.caption)
                                    .foregroundStyle(.yellow)
                            }
                        }
                        
                        // Module name
                        Text(module.name)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundStyle(.primary)
                            .lineLimit(2)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        // Module details
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                if !module.lecturer.isEmpty {
                                    Text(module.lecturer)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                        .lineLimit(1)
                                }
                                
                                Text(module.semester)
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                            }
                            
                            Spacer()
                            
                            // Grade and progress info
                            VStack(alignment: .trailing, spacing: 4) {
                                HStack(spacing: 4) {
                                    Text("Current:")
                                        .font(.caption2)
                                        .foregroundStyle(.secondary)
                                    
                                    Text(gradeString)
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                        .foregroundStyle(gradeColor)
                                }
                                
                                HStack(spacing: 4) {
                                    Text("\(Int(module.completionPercentage * 100))%")
                                        .font(.caption2)
                                        .fontWeight(.medium)
                                        .foregroundStyle(.primary)
                                    
                                    Text("complete")
                                        .font(.caption2)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                    }
                    
                    // Progress indicator and chevron
                    VStack(spacing: 8) {
                        CircularProgressView(
                            progress: module.completionPercentage,
                            color: Color.moduleColor(for: module.color)
                        )
                        
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundStyle(.tertiary)
                    }
                }
                .padding()
                
                // Assessment summary bar
                if !module.assessments.isEmpty {
                    AssessmentSummaryBar(module: module)
                }
            }
        }
        .buttonStyle(.plain)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(.separator), lineWidth: 0.5)
        )
    }
    
    // MARK: - Computed Properties
    
    private var gradeString: String {
        if module.finalGrade == 0 {
            return "N/A"
        }
        
        if systemType == .uk {
            return "\(module.finalGrade.rounded(to: 1))%"
        } else {
            let gpa = USGradeCalculator.getGradePoints(from: module.finalGrade)
            return gpa.gpaString
        }
    }
    
    private var gradeColor: Color {
        guard module.finalGrade > 0 else { return .gray }
        
        switch systemType {
        case .uk:
            switch module.finalGrade {
            case 70...: return .green
            case 60..<70: return .blue
            case 50..<60: return .orange
            case 40..<50: return .red
            default: return .gray
            }
        case .us:
            let gpa = USGradeCalculator.getGradePoints(from: module.finalGrade)
            switch gpa {
            case 3.5...: return .green
            case 3.0..<3.5: return .blue
            case 2.5..<3.0: return .orange
            case 2.0..<2.5: return .red
            default: return .gray
            }
        }
    }
}

struct AssessmentSummaryBar: View {
    let module: Module
    
    private var completedCount: Int {
        module.assessments.filter { $0.isCompleted }.count
    }
    
    private var totalCount: Int {
        module.assessments.count
    }
    
    private var upcomingCount: Int {
        module.assessments.filter { !$0.isCompleted && $0.dueDate != nil }.count
    }
    
    private var overdueCount: Int {
        module.assessments.filter { $0.isOverdue }.count
    }
    
    var body: some View {
        HStack {
            // Assessment counts
            HStack(spacing: 12) {
                AssessmentBadge(
                    count: completedCount,
                    label: "Done",
                    color: .green,
                    icon: "checkmark"
                )
                
                if upcomingCount > 0 {
                    AssessmentBadge(
                        count: upcomingCount,
                        label: "Due",
                        color: .orange,
                        icon: "clock"
                    )
                }
                
                if overdueCount > 0 {
                    AssessmentBadge(
                        count: overdueCount,
                        label: "Overdue",
                        color: .red,
                        icon: "exclamationmark.triangle"
                    )
                }
            }
            
            Spacer()
            
            Text("\(completedCount)/\(totalCount) assessments")
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(Color(.systemGray6))
    }
}

struct AssessmentBadge: View {
    let count: Int
    let label: String
    let color: Color
    let icon: String
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.caption2)
                .foregroundStyle(color)
            
            Text("\(count)")
                .font(.caption)
                .fontWeight(.medium)
                .foregroundStyle(color)
            
            Text(label)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    VStack(spacing: 12) {
        ModuleListItem(
            module: Student.sampleStudent.academicYears.first!.modules.first!,
            systemType: .uk
        ) {
            print("Tapped module")
        }
    }
    .padding()
    .background(Color(.systemGroupedBackground))
}

