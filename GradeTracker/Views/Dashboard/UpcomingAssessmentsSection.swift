//
//  UpcomingAssessmentsSection.swift
//  GradeTracker
//
//  Created by Snigdha Tiwari  on 26/08/2025.
//

import SwiftUI

struct UpcomingAssessmentsSection: View {
    let student: Student
    @State private var showingAllAssessments = false
    
    private var upcomingAssessments: [AssessmentWithModule] {
        student.academicYears
            .flatMap { year in
                year.modules.flatMap { module in
                    module.assessments
                        .filter { !$0.isCompleted }
                        .map { AssessmentWithModule(assessment: $0, module: module) }
                }
            }
            .sorted { $0.assessment.dueDate < $1.assessment.dueDate }
    }
    
    private var displayedAssessments: [AssessmentWithModule] {
        showingAllAssessments ? upcomingAssessments : Array(upcomingAssessments.prefix(4))
    }
    
    var body: some View {
        VStack(spacing: 16) {
            // Section Header
            HStack {
                HStack(spacing: 8) {
                    Image(systemName: "clock")
                        .foregroundStyle(.orange)
                        .font(.headline)
                    
                    Text("Upcoming Assessments")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    if upcomingAssessments.count > 0 {
                        Text("\(upcomingAssessments.count)")
                            .font(.caption2)
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(.orange)
                            .cornerRadius(8)
                    }
                }
                
                Spacer()
                
                if upcomingAssessments.count > 4 {
                    Button(action: {
                        withAnimation(.easeInOut) {
                            showingAllAssessments.toggle()
                        }
                    }) {
                        Image(systemName: showingAllAssessments ? "chevron.up" : "chevron.down")
                            .foregroundStyle(.secondary)
                            .font(.caption)
                    }
                }
            }
            
            // Assessments Content
            if upcomingAssessments.isEmpty {
                EmptyAssessmentsView()
            } else {
                LazyVStack(spacing: 8) {
                    ForEach(displayedAssessments, id: \.assessment.id) { item in
                        AssessmentRow(
                            assessment: item.assessment,
                            module: item.module
                        )
                        .transition(.asymmetric(
                            insertion: .move(edge: .trailing).combined(with: .opacity),
                            removal: .move(edge: .leading).combined(with: .opacity)
                        ))
                    }
                }
                
                if upcomingAssessments.count > 4 && !showingAllAssessments {
                    ShowMoreAssessmentsButton(count: upcomingAssessments.count - 4) {
                        withAnimation(.easeInOut) {
                            showingAllAssessments = true
                        }
                    }
                }
            }
        }
        .padding()
        .background(Color.cardBackground)
        .cornerRadius(16)
        .shadow(color: Color.cardShadow, radius: 8, x: 0, y: 4)
    }
}

struct AssessmentWithModule {
    let assessment: Assessment
    let module: Module
}

struct EmptyAssessmentsView: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 40))
                .foregroundStyle(.green)
            
            Text("All caught up!")
                .font(.headline)
                .foregroundStyle(.primary)
            
            Text("No upcoming assessments")
                .font(.caption)
                .foregroundStyle(.secondary)
            
            Text("Great job staying on top of your work! 🎉")
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.vertical, 20)
    }
}

struct ShowMoreAssessmentsButton: View {
    let count: Int
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Text("Show \(count) more assessment\(count == 1 ? "" : "s")")
                    .font(.caption)
                    .fontWeight(.medium)
                
                Image(systemName: "chevron.down")
                    .font(.caption2)
            }
            .foregroundStyle(.orange)
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .background(.orange.opacity(0.1))
            .cornerRadius(8)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    UpcomingAssessmentsSection(student: Student.createSampleStudent())
        .padding()
        .background(Color(.systemGroupedBackground))
}

