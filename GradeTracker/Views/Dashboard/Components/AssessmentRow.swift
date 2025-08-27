//
//  AssessmentRow.swift
//  GradeTracker
//
//  Created by Snigdha Tiwari  on 26/08/2025.
//

// Views/Dashboard/Components/AssessmentRow.swift
import SwiftUI

struct AssessmentRow: View {
    let title: String
    let dueDate: Date
    let isCompleted: Bool
    let grade: Double?
    let weighting: Double
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            // Status indicator
            Circle()
                .fill(isCompleted ? .green :
                      (dueDate < Date() ? .red : .orange))
                .frame(width: 8, height: 8)
            
            VStack(alignment: .leading, spacing: 2) {
                HStack {
                    Text(title)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .lineLimit(1)
                    
                    Spacer()
                    
                    Text("\(Int(weighting))%")
                        .font(.caption2)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    Text(dueDate.formatted(date: .abbreviated, time: .omitted))
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    if let grade = grade {
                        Text("\(String(format: "%.0f%%", grade))")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(color)
                    }
                }
            }
        }
        .padding(.vertical, 4)
    }
}
