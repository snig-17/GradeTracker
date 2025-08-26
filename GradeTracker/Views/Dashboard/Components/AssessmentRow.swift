//
//  AssessmentRow.swift
//  GradeTracker
//
//  Created by Snigdha Tiwari  on 26/08/2025.
//

import SwiftUI

struct AssessmentRow: View {
    let assessment: Assessment
    let module: Module?
    
    var body: some View {
        HStack(spacing: 12) {
            // Assessment type icon with priority indicator
            ZStack {
                Circle()
                    .fill(priorityColor.opacity(0.1))
                    .frame(width: 36, height: 36)
                
                Image(systemName: assessment.type.icon)
                    .foregroundStyle(priorityColor)
                    .font(.system(size: 16, weight: .medium))
            }
            
            VStack(alignment: .leading, spacing: 4) {
                // Assessment name and weighting
                HStack {
                    Text(assessment.name)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .lineLimit(1)
                        .foregroundStyle(.primary)
                    
                    Spacer()
                    
                    Text("\(Int(assessment.weighting))%")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(.secondary.opacity(0.1))
                        .cornerRadius(4)
                }
                
                // Module and due date info
                HStack {
                    if let module = module {
                        Text(module.code)
                            .font(.caption2)
                            .fontWeight(.medium)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.moduleColor(for: module.color).opacity(0.2))
                            .foregroundStyle(Color.moduleColor(for: module.color))
                            .cornerRadius(4)
                    }
                    
                    Text("•")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                    
                    Text(assessment.type.rawValue)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                    
                    Spacer()
                    
                    if let dueDate = assessment.dueDate {
                        HStack(spacing: 4) {
                            Image(systemName: urgencyIcon)
                                .font(.caption2)
                                .foregroundStyle(priorityColor)
                            
                            Text(dueDate.relativeString)
                                .font(.caption)
                                .foregroundStyle(priorityColor)
                                .fontWeight(.medium)
                        }
                    }
                }
            }
            
            // Status indicator
            if assessment.isCompleted {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(.green)
                    .font(.title3)
            } else if assessment.isOverdue {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundStyle(.red)
                    .font(.title3)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(backgroundColor)
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(priorityColor.opacity(assessment.isOverdue ? 0.5 : 0.2), lineWidth: assessment.isOverdue ? 2 : 1)
        )
        .shadow(color: priorityColor.opacity(assessment.isOverdue ? 0.2 : 0.05), radius: assessment.isOverdue ? 4 : 2, x: 0, y: 1)
    }
    
    private var priorityColor: Color {
        if assessment.isCompleted {
            return .green
        }
        
        guard let daysUntil = assessment.daysUntilDue else { return .secondary }
        
        if assessment.isOverdue {
            return .red
        } else if daysUntil <= 1 {
            return .red
        } else if daysUntil <= 3 {
            return .orange
        } else if daysUntil <= 7 {
            return .yellow
        } else {
            return .green
        }
    }
    
    private var urgencyIcon: String {
        if assessment.isOverdue {
            return "exclamationmark.triangle"
        }
        
        guard let daysUntil = assessment.daysUntilDue else { return "calendar" }
        
        if daysUntil <= 1 {
            return "alarm"
        } else if daysUntil <= 3 {
            return "clock.badge.exclamationmark"
        } else {
            return "calendar"
        }
    }
    
    private var backgroundColor: Color {
        if assessment.isCompleted {
            return .green.opacity(0.05)
        } else if assessment.isOverdue {
            return .red.opacity(0.05)
        } else {
            return Color(.systemBackground)
        }
    }
}

#Preview {
    VStack(spacing: 8) {
        // Upcoming assessment
        AssessmentRow(
            assessment: Student.sampleStudent.academicYears.first!.modules.first!.assessments.first!,
            module: Student.sampleStudent.academicYears.first!.modules.first!
        )
        
        // Overdue assessment
        AssessmentRow(
            assessment: {
                let assessment = Assessment(
                    name: "Overdue Essay",
                    type: .essay,
                    weighting: 30.0,
                    dueDate: Calendar.current.date(byAdding: .day, value: -2, to: Date())
                )
                return assessment
            }(),
            module: Student.sampleStudent.academicYears.first!.modules.first!
        )
        
        // Completed assessment
        AssessmentRow(
            assessment: {
                let assessment = Assessment(
                    name: "Completed Lab",
                    type: .labWork,
                    weighting: 25.0
                )
                assessment.isCompleted = true
                assessment.percentage = 85.0
                return assessment
            }(),
            module: Student.sampleStudent.academicYears.first!.modules.first!
        )
    }
    .padding()
    .background(Color(.systemGroupedBackground))
}

