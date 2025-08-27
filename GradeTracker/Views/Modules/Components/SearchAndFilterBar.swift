//
//  SearchAndFilterBar.swift
//  GradeTracker
//
//  Created by Snigdha Tiwari  on 26/08/2025.
//

import SwiftUI

struct SearchAndFilterBar: View {
    @Binding var searchText: String
    @Binding var selectedSemester: String
    @Binding var showingFilters: Bool
    let availableSemesters: [String]
    
    var body: some View {
        VStack(spacing: 12) {
            // Search Bar
            HStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(.secondary)
                    
                    TextField("Search modules...", text: $searchText)
                        .textFieldStyle(.plain)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                
                Button(action: { showingFilters.toggle() }) {
                    Image(systemName: showingFilters ? "line.3.horizontal.decrease.circle.fill" : "line.3.horizontal.decrease.circle")
                        .foregroundStyle(.blue)
                        .font(.title2)
                }
            }
            
            // Filter Options (expandable)
            if showingFilters {
                VStack(spacing: 12) {
                    // Semester Filter
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Semester")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundStyle(.secondary)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(availableSemesters, id: \.self) { semester in
                                    FilterChip(
                                        text: semester,
                                        isSelected: selectedSemester == semester
                                    ) {
                                        selectedSemester = semester
                                    }
                                }
                            }
                            .padding(.horizontal, 1)
                        }
                    }
                    
                    Divider()
                    
                    // Quick Actions
                    HStack {
                        Text("\(getFilteredCount()) modules")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        
                        Spacer()
                        
                        if selectedSemester != "All" || !searchText.isEmpty {
                            Button("Clear Filters") {
                                selectedSemester = "All"
                                searchText = ""
                            }
                            .font(.caption)
                            .foregroundStyle(.blue)
                        }
                    }
                }
                .padding(.vertical, 8)
                .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(Color(.systemBackground))
        .shadow(color: .black.opacity(0.05), radius: 1, x: 0, y: 1)
        .animation(.easeInOut(duration: 0.2), value: showingFilters)
    }
    
    private func getFilteredCount() -> Int {
        // This would ideally be passed from parent view
        return 0 // Placeholder
    }
}

struct FilterChip: View {
    let text: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(text)
                .font(.caption)
                .fontWeight(.medium)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(isSelected ? Color.blue : Color(.systemGray5))
                .foregroundStyle(isSelected ? .white : .primary)
                .cornerRadius(16)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    SearchAndFilterBar(
        searchText: .constant(""),
        selectedSemester: .constant("All"),
        showingFilters: .constant(true),
        availableSemesters: ["All", "Semester 1", "Semester 2", "Summer"]
    )
}

