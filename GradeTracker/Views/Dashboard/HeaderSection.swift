import SwiftUI

struct HeaderSection: View {
    let student: Student
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Welcome back,")
                        .font(.title3)
                        .foregroundStyle(.secondary)
                    
                    Text(student.name)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                }
                
                Spacer()
                
                ProfileAvatarView(student: student)
            }
            
            HStack {
                Image(systemName: "building.2")
                    .foregroundStyle(.secondary)
                    .font(.caption)
                
                Text(student.course)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text("•")
                    .foregroundStyle(.secondary)
                
                Text(student.university)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
            HStack {
                Image(systemName: "calendar")
                    .foregroundStyle(.secondary)
                    .font(.caption)
                
                Text("Year \(currentAcademicYear) • \(student.systemType.rawValue)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                Spacer()
            }
        }
        .padding()
        .background(Color.cardBackground)
        .cornerRadius(16)
        .shadow(color: Color.cardShadow, radius: 8, x: 0, y: 4)
    }
    
    private var currentAcademicYear: Int {
        student.academicYears.first(where: { $0.isActive })?.level ?? 1
    }
}

struct ProfileAvatarView: View {
    let student: Student
    
    var body: some View {
        Circle()
            .fill(
                LinearGradient(
                    colors: [.blue, .purple],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .frame(width: 60, height: 60)
            .overlay(
                Text(student.name.prefix(1).uppercased())
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
            )
            .shadow(color: .blue.opacity(0.3), radius: 4, x: 0, y: 2)
    }
}

#Preview {
    HeaderSection(student: Student(
        name: "Santosh Kumar",
        studentNumber: "12345",
        university: "University of London",
        course: "Computer Science",
        systemType: .uk,
        startYear: 2023
    ))
    .padding()
    .background(Color(.systemGroupedBackground))
}
