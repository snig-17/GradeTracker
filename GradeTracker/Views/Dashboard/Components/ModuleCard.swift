//
//  ModuleCard.swift
//  GradeTracker
//
//  Created by Snigdha Tiwari  on 26/08/2025.
//

import SwiftUI

struct ModuleCard: View {
    let module: Module
    let systemType: GradingSystem
    
    var body: some View {
        HStack(spacing: 12) {
            // Module color indicator
            RoundedRectangle(cornerRadius: 4)
                .fill(Color.moduleColor(for: module.color))
                .frame(width: 4, height: 60)
            
            VStack(alignment: .leading, spacing: 6) {
                // Header row
                HStack {
                    Text(module.code)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.moduleColor(for: module.color))
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.moduleColor(for: module.color).opacity(0.1))
                        .cornerRadius(4)
                    
                    Spacer()
                    
                    Text("\(module.credits) credits")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                    
                    if module.isCore {
                        Image(systemName: "star.fill")
                            .font(.caption2)
                            .foregroundStyle(.yellow)
                    }
                }
                
                // Module name
                Text(module.name)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .lineLimit(2)
                    .minimumScaleFactor(0.9)
                
                // Stats row
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Current: \(module.finalGrade.rounded(to: 1), specifier: "%.1f")\(systemType == .uk ? "%" : "")")
                            .font(.caption)
                            .foregroundStyle(gradeColor)
                            .fontWeight(.medium)
                        
                        if !module.lecturer.isEmpty {
                            Text(module.lecturer)
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                                .lineLimit(1)
                        }
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 2) {
                        Text("\(Int(module.completionPercentage * 100))%")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundStyle(.primary)
                        
                        Text("Complete")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            
            // Progress indicator
            CircularProgressView(
                progress: module.completionPercentage,
                color: Color.moduleColor(for: module.color)
            )
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(.separator), lineWidth: 0.5)
        )
        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
    
    private var gradeColor: Color {
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
            let gpa = module.finalGrade / 25.0 // Rough conversion for display
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

struct CircularProgressView: View {
    let progress: Double
    let color: Color
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(color.opacity(0.2), lineWidth: 3)
                .frame(width: 32, height: 32)
            
            Circle()
                .trim(from: 0, to: progress)
                .stroke(color, style: StrokeStyle(lineWidth: 3, lineCap: .round))
                .frame(width: 32, height: 32)
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: 0.5), value: progress)
            
            Text("\(Int(progress * 100))")
                .font(.caption2)
                .fontWeight(.semibold)
                .foregroundStyle(color)
        }
    }
}

#Preview {
    VStack(spacing: 12) {
        ModuleCard(module: Student.sampleStudent.academicYears.first!.modules.first!, systemType: .uk)
        ModuleCard(module: Student.sampleStudent.academicYears.first!.modules.first!, systemType: .us)
    }
    .padding()
    .background(Color(.systemGroupedBackground))
}

