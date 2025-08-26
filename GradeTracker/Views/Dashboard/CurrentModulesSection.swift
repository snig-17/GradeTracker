//
//  CurrentModulesSection.swift
//  GradeTracker
//
//  Created by Snigdha Tiwari  on 26/08/2025.
//

import SwiftUI

struct CurrentModulesSection: View {
    let student: Student
    @State private var showingAllModules = false
    
    private var currentModules: [Module] {
        student.academicYears
            .first(where: { $0.isActive })?
            .modules ?? []
    }
    
    private var displayedModules: [Module] {
        showingAllModules ? currentModules : Array(currentModules.prefix(3))
    }
    
    var body: some View {
        VStack(spacing: 16) {
            // Section Header
            HStack {
                HStack(spacing: 8) {
                    Image(systemName: "books.vertical")
                        .foregroundStyle(.blue)
                        .font(.headline)
                    
                    Text("Current Modules")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    if currentModules.count > 0 {
                        Text("\(currentModules.count)")
                            .font(.caption2)
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(.blue)
                            .cornerRadius(8)
                    }
                }
                
                Spacer()
                
                if currentModules.count > 3 {
                    Button(action: {
                        withAnimation(.easeInOut) {
                            showingAllModules.toggle()
                        }
                    }) {
                        Image(systemName: showingAllModules ? "chevron.up" : "chevron.down")
                            .foregroundStyle(.secondary)
                            .font(.caption)
                    }
                }
            }
            
            // Modules Content
            if currentModules.isEmpty {
                EmptyModulesView()
            } else {
                LazyVStack(spacing: 12) {
                    ForEach(displayedModules, id: \.id) { module in
                        ModuleCard(module: module, systemType: student.systemType)
                            .transition(.asymmetric(
                                insertion: .move(edge: .trailing).combined(with: .opacity),
                                removal: .move(edge: .leading).combined(with: .opacity)
                            ))
                    }
                }
                
                if currentModules.count > 3 && !showingAllModules {
                    ShowMoreModulesButton(count: currentModules.count - 3) {
                        withAnimation(.easeInOut) {
                            showingAllModules = true
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

struct EmptyModulesView: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "book.closed")
                .font(.system(size: 40))
                .foregroundStyle(.secondary)
            
            Text("No modules this semester")
                .font(.headline)
                .foregroundStyle(.primary)
            
            Text("Add your first module to start tracking")
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            
            Button("Add Module") {
                // TODO: Navigate to add module
            }
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.roundedRectangle(radius: 8))
        }
        .padding(.vertical, 20)
    }
}

struct ShowMoreModulesButton: View {
    let count: Int
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Text("Show \(count) more module\(count == 1 ? "" : "s")")
                    .font(.caption)
                    .fontWeight(.medium)
                
                Image(systemName: "chevron.down")
                    .font(.caption2)
            }
            .foregroundStyle(.blue)
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .background(.blue.opacity(0.1))
            .cornerRadius(8)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    CurrentModulesSection(student: Student.sampleStudent)
        .padding()
        .background(Color(.systemGroupedBackground))
}
