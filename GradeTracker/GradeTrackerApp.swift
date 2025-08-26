//
//  GradeTrackerApp.swift
//  GradeTracker
//
//  Created by Snigdha Tiwari  on 26/08/2025.
//

import SwiftUI
import SwiftData

@main
struct GradeTrackerApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Student.self,
            AcademicYear.self,
            Module.self,
            Assessment.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}


