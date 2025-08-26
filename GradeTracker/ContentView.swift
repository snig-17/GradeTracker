//
//  ContentView.swift
//  GradeTracker
//
//  Created by Snigdha Tiwari  on 26/08/2025.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var students: [Student]
    
    var body: some View {
        NavigationView {
            if students.isEmpty {
                // Show onboarding or create sample data
                VStack(spacing: 20) {
                    Text("Welcome to Grade Tracker!")
                        .font(.title)
                    
                    Button("Create Sample Student") {
                        createSampleStudent()
                    }
                    .buttonStyle(.borderedProminent)
                }
            } else {
                DashboardView()
            }
        }
    }
    
    private func createSampleStudent() {
        let student = Student(
            name: "Santosh Kumar",
            studentNumber: "12345678",
            university: "University of London",
            course: "Computer Science BSc",
            systemType: .uk,
            startYear: 2023
        )
        
        modelContext.insert(student)
        
        do {
            try modelContext.save()
        } catch {
            print("Error saving student: \(error)")
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [Student.self, AcademicYear.self, Module.self, Assessment.self], inMemory: true)
}
