//
//  ModulesView.swift
//  GradeTracker
//
//  Created by Snigdha Tiwari  on 26/08/2025.
//

import SwiftUI
import SwiftData

struct ModulesView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var students: [Student]
    
    @State private var selectedSemester: String = "All"
    @State private var searchText = ""
    @State private var showingAddModule = false
    @State private var selectedModule: Module?
    @State private var showingFilters = false
    
    private var currentStudent: Student? {
        students.first
    }
    
    private var allModules: [Module] {
        currentStudent?.academicYears.flatMap { $0.modules } ?? []
    }
    
    private var filteredModules: [Module] {
        var modules = allModules
        
        // Filter by semester
        if selectedSemester != "All" {
            modules = modules.filter { $0.semester == selectedSemester }
        }
        
        // Filter by search text
        if !searchText.isEmpty {
            modules = modules.filter { module in
                module.name.localizedCaseInsensitiveContains(searchText) ||
                module.code.localizedCaseInsensitiveContains(searchText) ||
                module.lecturer.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        return modules.sorted { $0.name < $1.name }
    }
    
    private var availableSemesters: [String] {
        let semesters = Set(allModules.map { $0.semester })
        return ["All"] + semesters.sorted()
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Search and Filter Bar
                SearchAndFilterBar(
                    searchText: $searchText,
                    selectedSemester: $selectedSemester,
                    showingFilters: $showingFilters,
                    availableSemesters: availableSemesters
                    
                )
                
                // Module Statistics Cards
                if currentStudent != nil {
                    ModuleStatsSection(modules: filteredModules)
                        .padding(.horizontal)
                        .padding(.top)
                }
                
                // Modules List
                ScrollView {
                    LazyVStack(spacing: 12) {
                        if filteredModules.isEmpty {
                            EmptyModulesState(
                                isFiltered: selectedSemester != "All" || !searchText.isEmpty,
                                onAddModule: { showingAddModule = true }
                            )
                        } else {
                            ForEach(filteredModules, id: \.id) { module in
                                ModuleListItem(
                                    module: module,
                                    systemType: currentStudent?.systemType ?? .uk
                                ) {
                                    selectedModule = module
                                }
                                .transition(.asymmetric(
                                    insertion: .move(edge: .trailing).combined(with: .opacity),
                                    removal: .move(edge: .leading).combined(with: .opacity)
                                ))
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 100) // Space for floating button
                }
                .refreshable {
                    // Refresh data if needed
                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Modules")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddModule = true }) {
                        Image(systemName: "plus")
                            .fontWeight(.semibold)
                    }
                }
            }
            .overlay(alignment: .bottomTrailing) {
                // Floating Action Button
                FloatingActionButton {
                    showingAddModule = true
                }
                .padding(.trailing, 20)
                .padding(.bottom, 30)
            }
        }
        .sheet(isPresented: $showingAddModule) {
            AddModuleView()
        }
        .sheet(item: $selectedModule) { module in
            ModuleDetailView(module: module)
        }
        .animation(.easeInOut(duration: 0.3), value: filteredModules.count)
    }
}

#Preview {
    ModulesView()
        .modelContainer(for: [Student.self, AcademicYear.self, Module.self, Assessment.self], inMemory: true)
}

