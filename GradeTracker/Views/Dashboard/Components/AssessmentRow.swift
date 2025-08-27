//
//  AssessmentRow.swift
//  GradeTracker
//
//  Created by Snigdha Tiwari  on 26/08/2025.
//

// Views/Dashboard/Components/AssessmentRow.swift
import SwiftUI

struct AssessmentRow: View {
    let assessment: Assessment
    let module: Module
    
    var body: some View {
        HStack(spacing: 12) {
            // Status indicator
            Circle()
                .fill(assessment.isCompleted ? .green :
                      (assessment.dueDate < Date() ? .red : .orange))
                .frame(width: 8, height: 8)
            
            VStack(alignment: .leading, spacing: 2) {
                HStack {
                    Text(assessment.title)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .lineLimit(1)
                    
                    Spacer()
                    
                    Text("\(Int(assessment.weighting))%")
                        .font(.caption2)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    Text(assessment.dueDate.formatted(date: .abbreviated, time: .omitted))
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text("•")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text(module.code)
                        .font(.caption)
                        .foregroundColor(Color(hex: module.colorHex))
                        .fontWeight(.medium)
                    
                    Spacer()
                    
                    if let grade = assessment.grade {
                        Text("\(String(format: "%.0f%%", grade))")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(Color(hex: module.colorHex))
                    }
                }
            }
        }
        .padding(.vertical, 4)
    }
}
