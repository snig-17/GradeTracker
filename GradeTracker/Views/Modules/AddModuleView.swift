//
//  AddModuleView.swift
//  GradeTracker
//
//  Created by Snigdha Tiwari  on 27/08/2025.
//

// Views/Modules/AddModuleView.swift
import SwiftUI
import SwiftData

struct AddModuleView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var moduleName = ""
    @State private var moduleCode = ""
    @State private var credits = 15
    @State private var semester = "Semester 1"
    @State private var academicYear = "2024-25"
    @State private var lecturer = ""
    @State private var description = ""
    @State private var selectedColor = Color.blue
    @State private var gradeSystem: GradeSystem = .uk
    
    // Validation states
    @State private var showingValidationAlert = false
    @State private var validationMessage = ""
    
    private let availableCredits = [15, 20, 30, 60] // UK system
    private let availableCreditHours = [3, 4, 6] // US system
    private let semesters = ["Semester 1", "Semester 2", "Summer"]
    private let moduleColors: [Color] = [.blue, .green, .orange, .purple, .red, .pink, .indigo, .teal]
    
    var body: some View {
        NavigationView {
            Form {
                // Basic Information Section
                Section("Module Information") {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Module Name")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        TextField("e.g., Advanced Mathematics", text: $moduleName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Module Code")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        TextField("e.g., MATH301", text: $moduleCode)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .autocapitalization(.allCharacters)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Lecturer")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        TextField("Professor name (optional)", text: $lecturer)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                }
                
                // Academic Details Section
                Section("Academic Details") {
                    Picker("Grade System", selection: $gradeSystem) {
                        Text("UK System").tag(GradeSystem.uk)
                        Text("US System").tag(GradeSystem.us)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                    HStack {
                        Text(gradeSystem == .uk ? "Credits" : "Credit Hours")
                        Spacer()
                        Picker("Credits", selection: $credits) {
                            ForEach(gradeSystem == .uk ? availableCredits : availableCreditHours, id: \.self) { credit in
                                Text("\(credit)").tag(credit)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                    }
                    
                    Picker("Semester", selection: $semester) {
                        ForEach(semesters, id: \.self) { semester in
                            Text(semester).tag(semester)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Academic Year")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        TextField("e.g., 2024-25", text: $academicYear)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                }
                
                // Customization Section
                Section("Customization") {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Module Color")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 12) {
                            ForEach(Array(moduleColors.enumerated()), id: \.offset) { index, color in
                                Circle()
                                    .fill(color)
                                    .frame(width: 40, height: 40)
                                    .overlay(
                                        Circle()
                                            .stroke(Color.primary, lineWidth: selectedColor == color ? 3 : 0)
                                    )
                                    .onTapGesture {
                                        selectedColor = color
                                    }
                            }
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Description (Optional)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        TextField("Module description...", text: $description, axis: .vertical)
                            .lineLimit(3...6)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                }
                
                // Preview Section
                Section("Preview") {
                    ModulePreviewCard(
                        name: moduleName.isEmpty ? "Module Name" : moduleName,
                        code: moduleCode.isEmpty ? "CODE" : moduleCode,
                        credits: credits,
                        semester: semester,
                        lecturer: lecturer,
                        color: selectedColor,
                        gradeSystem: gradeSystem
                    )
                }
            }
            .navigationTitle("Add Module")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveModule()
                    }
                    .fontWeight(.semibold)
                    .disabled(!isFormValid)
                }
            }
        }
        .alert("Validation Error", isPresented: $showingValidationAlert) {
            Button("OK") { }
        } message: {
            Text(validationMessage)
        }
    }
    
    private var isFormValid: Bool {
        !moduleName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !moduleCode.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !academicYear.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    private func saveModule() {
        // Validate input
        guard isFormValid else {
            validationMessage = "Please fill in all required fields (Module Name, Code, and Academic Year)."
            showingValidationAlert = true
            return
        }
        
        // Create new module
        let newModule = Module(
                name: moduleName.trimmingCharacters(in: .whitespacesAndNewlines),
                code: moduleCode.trimmingCharacters(in: .whitespacesAndNewlines).uppercased(),
                credits: credits,
                semester: semester,
                academicYear: academicYear.trimmingCharacters(in: .whitespacesAndNewlines),
                lecturer: lecturer.trimmingCharacters(in: .whitespacesAndNewlines),
                description: description.trimmingCharacters(in: .whitespacesAndNewlines), // This maps to moduleDescription internally
                colorHex: selectedColor.toHex() ?? "#007AFF",
                gradeSystem: gradeSystem
            )
        
        // Insert into context
        modelContext.insert(newModule)
        
        // Save
        do {
            try modelContext.save()
            dismiss()
        } catch {
            validationMessage = "Failed to save module. Please try again."
            showingValidationAlert = true
        }
    }
}

struct ModulePreviewCard: View {
    let name: String
    let code: String
    let credits: Int
    let semester: String
    let lecturer: String
    let color: Color
    let gradeSystem: GradeSystem
    
    var body: some View {
        HStack(spacing: 16) {
            // Color indicator
            RoundedRectangle(cornerRadius: 8)
                .fill(color)
                .frame(width: 4, height: 60)
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(name)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .lineLimit(1)
                    
                    Spacer()
                    
                    Text(code)
                        .font(.caption)
                        .fontWeight(.medium)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color(.systemGray5))
                        .cornerRadius(6)
                }
                
                HStack {
                    Label("\(credits) \(gradeSystem == .uk ? "Credits" : "Hours")", systemImage: "book.fill")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Text(semester)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                if !lecturer.isEmpty {
                    Text(lecturer)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}

// Extension to convert Color to hex
extension Color {
    func toHex() -> String? {
        let uic = UIColor(self)
        guard let components = uic.cgColor.components, components.count >= 3 else {
            return nil
        }
        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        return String(format: "#%02lX%02lX%02lX",
                     lroundf(r * 255),
                     lroundf(g * 255),
                     lroundf(b * 255))
    }
}
