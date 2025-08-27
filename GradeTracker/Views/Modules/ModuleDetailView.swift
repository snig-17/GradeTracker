//
//  ModuleDetailView.swift
//  GradeTracker
//
//  Created by Snigdha Tiwari  on 27/08/2025.
//

import SwiftUI
import SwiftData

struct ModuleDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    let module: Module
    @State private var showingEditSheet = false
    @State private var showingDeleteAlert = false
    @State private var showingAddAssessmentSheet = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header Section
                ModuleHeaderSection(module: module)
                
                // Quick Stats
                ModuleQuickStats(module: module)
                
                // Assessments Section
                AssessmentsSection(
                    module: module,
                    showingAddAssessmentSheet: $showingAddAssessmentSheet
                )
                
                // Performance Chart
                if !module.assessments.isEmpty {
                    PerformanceChartSection(module: module)
                }
                
                // Module Information
                ModuleInformationSection(module: module)
                
                Spacer(minLength: 100)
            }
            .padding()
        }
        .navigationTitle(module.code)
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button {
                        showingEditSheet = true
                    } label: {
                        Label("Edit Module", systemImage: "pencil")
                    }
                    
                    Button {
                        showingAddAssessmentSheet = true
                    } label: {
                        Label("Add Assessment", systemImage: "plus.circle")
                    }
                    
                    Divider()
                    
                    Button(role: .destructive) {
                        showingDeleteAlert = true
                    } label: {
                        Label("Delete Module", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
        }
        .sheet(isPresented: $showingEditSheet) {
            EditModuleView(module: module)
        }
        .sheet(isPresented: $showingAddAssessmentSheet) {
            AddAssessmentView(module: module)
        }
        .alert("Delete Module", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                deleteModule()
            }
        } message: {
            Text("Are you sure you want to delete this module? This action cannot be undone.")
        }
    }
    
    private func deleteModule() {
        modelContext.delete(module)
        try? modelContext.save()
        dismiss()
    }
}

// MARK: - Header Section
struct ModuleHeaderSection: View {
    let module: Module
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text(module.name)
                        .font(.title2)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.leading)
                    
                    Text(module.code)
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    if !module.lecturer.isEmpty {
                        Label(module.lecturer, systemImage: "person.fill")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    if let currentGrade = module.currentGrade {
                        Text(String(format: "%.1f%%", currentGrade))
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(Color(hex: module.colorHex))
                        
                        Text(module.gradeSystem == .uk ?
                             GradeCalculator.getUKGradeBand(for: currentGrade) :
                             GradeCalculator.getUSLetterGrade(for: currentGrade))
                            .font(.caption)
                            .fontWeight(.medium)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background(Color(hex: module.colorHex).opacity(0.1))
                            .foregroundColor(Color(hex: module.colorHex))
                            .cornerRadius(8)
                    } else {
                        Text("No Grade")
                            .font(.title3)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(hex: module.colorHex).opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color(hex: module.colorHex).opacity(0.3), lineWidth: 1)
                    )
            )
        }
    }
}

// MARK: - Quick Stats
struct ModuleQuickStats: View {
    let module: Module
    
    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
            StatCard(
                title: module.gradeSystem == .uk ? "Credits" : "Credit Hours",
                value: "\(module.credits)",
                icon: "book.fill",
                color: .blue
            )
            
            StatCard(
                title: "Semester",
                value: module.semester,
                icon: "calendar",
                color: .green
            )
            
            StatCard(
                title: "Assessments",
                value: "\(module.assessments.count)",
                icon: "doc.text.fill",
                color: .orange
            )
            
            StatCard(
                title: "Completed",
                value: "\(module.assessments.filter { $0.isCompleted }.count)",
                icon: "checkmark.circle.fill",
                color: .purple
            )
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                    .font(.title3)
                
                Spacer()
                
                Text(value)
                    .font(.title2)
                    .fontWeight(.bold)
            }
            
            HStack {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Spacer()
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

// MARK: - Assessments Section
struct AssessmentsSection: View {
    let module: Module
    @Binding var showingAddAssessmentSheet: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Assessments")
                    .font(.headline)
                    .fontWeight(.bold)
                
                Spacer()
                
                Button {
                    showingAddAssessmentSheet = true
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(.blue)
                        .font(.title3)
                }
            }
            
            if module.assessments.isEmpty {
                EmptyAssessmentsView()
            } else {
                LazyVStack(spacing: 12) {
                    ForEach(module.assessments.sorted { $0.dueDate < $1.dueDate }) { assessment in
                        AssessmentCard(assessment: assessment)
                    }
                }
            }
        }
    }
}

struct EmptyAssessmentsView: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "doc.text.below.ecg")
                .font(.system(size: 48))
                .foregroundColor(.secondary)
            
            Text("No Assessments")
                .font(.headline)
                .foregroundColor(.secondary)
            
            Text("Add your first assessment to start tracking your progress")
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(32)
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct AssessmentCard: View {
    let assessment: Assessment
    
    var body: some View {
        HStack(spacing: 16) {
            // Status indicator
            Circle()
                .fill(assessment.isCompleted ? .green :
                      (assessment.dueDate < Date() ? .red : .orange))
                .frame(width: 12, height: 12)
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(assessment.title)
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    Spacer()
                    
                    Text("\(Int(assessment.weighting))%")
                        .font(.caption)
                        .fontWeight(.medium)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color(.systemGray5))
                        .cornerRadius(4)
                }
                
                HStack {
                    Text(assessment.type.rawValue)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Text(assessment.dueDate.formatted(date: .abbreviated, time: .omitted))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                if let grade = assessment.grade {
                    Text("Grade: \(String(format: "%.1f%%", grade))")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.blue)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}

// MARK: - Performance Chart Section
struct PerformanceChartSection: View {
    let module: Module
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Performance Trend")
                .font(.headline)
                .fontWeight(.bold)
            
            // Simple performance visualization
            VStack(spacing: 8) {
                ForEach(module.assessments.compactMap { $0.grade != nil ? $0 : nil }.sorted { $0.dueDate < $1.dueDate }) { assessment in
                    HStack {
                        Text(assessment.title)
                            .font(.caption)
                            .frame(width: 80, alignment: .leading)
                        
                        GeometryReader { geometry in
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color(hex: module.colorHex).opacity(0.3))
                                .frame(height: 8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(Color(hex: module.colorHex))
                                        .frame(width: geometry.size.width * CGFloat((assessment.grade ?? 0) / 100), height: 8),
                                    alignment: .leading
                                )
                        }
                        .frame(height: 8)
                        
                        Text(String(format: "%.0f%%", assessment.grade ?? 0))
                            .font(.caption)
                            .fontWeight(.medium)
                            .frame(width: 40, alignment: .trailing)
                    }
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
        }
    }
}

// MARK: - Module Information Section
struct ModuleInformationSection: View {
    let module: Module
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Module Information")
                .font(.headline)
                .fontWeight(.bold)
            
            VStack(spacing: 12) {
                InfoRow(title: "Academic Year", value: module.academicYear)
                InfoRow(title: "Grade System", value: module.gradeSystem == .uk ? "UK System" : "US System")
                
                if !module.description.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Description")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.secondary)
                        
                        Text(module.description)
                            .font(.body)
                            .multilineTextAlignment(.leading)
                    }
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
        }
    }
}

struct InfoRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.secondary)
            
            Spacer()
            
            Text(value)
                .font(.subheadline)
                .fontWeight(.medium)
        }
    }
}

// Placeholder views for the sheets
struct EditModuleView: View {
    let module: Module
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            Text("Edit Module View")
                .navigationTitle("Edit Module")
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Cancel") { dismiss() }
                    }
                }
        }
    }
}

struct AddAssessmentView: View {
    let module: Module
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            Text("Add Assessment View")
                .navigationTitle("Add Assessment")
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Cancel") { dismiss() }
                    }
                }
        }
    }
}

