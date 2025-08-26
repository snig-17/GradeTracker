//
//  DashboardView.swift
//  GradeTracker
//
//  Created by Snigdha Tiwari  on 26/08/2025.
//

import SwiftUI
import SwiftData

struct DashboardView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var students: [Student]
    
    var currentStudent: Student? {
        students.first
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 20) {
                    if let student = currentStudent {
                        HeaderSection(student: student)
                        GPAOverviewSection(student: student)
                        CurrentModulesSection(student: student)
                        UpcomingAssessmentsSection(student: student)
                        ProgressChartSection(student: student)
                    } else {
                        EmptyStateView()
                    }
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Dashboard")
            .navigationBarTitleDisplayMode(.large)
            .refreshable {
                // Refresh data if needed
            }
        }
    }
}

struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "graduationcap.circle")
                .font(.system(size: 80))
                .foregroundStyle(.secondary)
            
            Text("Welcome to Grade Tracker!")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Create your student profile to start tracking your academic progress")
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            
            Button("Get Started") {
                // TODO: Navigate to onboarding
            }
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.roundedRectangle(radius: 12))
        }
        .padding()
    }
}

#Preview {
    DashboardView()
        .modelContainer(for: [Student.self, AcademicYear.self, Module.self, Assessment.self], inMemory: true)
}
