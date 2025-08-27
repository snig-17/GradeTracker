//
//  EmptyModulesState.swift
//  GradeTracker
//
//  Created by Snigdha Tiwari  on 26/08/2025.
//

import SwiftUI

struct EmptyModulesState: View {
    let isFiltered: Bool
    let onAddModule: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            // Icon
            Image(systemName: isFiltered ? "magnifyingglass" : "books.vertical")
                .font(.system(size: 60))
                .foregroundStyle(.secondary)
            
            // Title and message
            VStack(spacing: 8) {
                Text(isFiltered ? "No modules found" : "No modules yet")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundStyle(.primary)
                
                Text(isFiltered ?
                     "Try adjusting your search or filters" :
                     "Add your first module to start tracking your grades")
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            
            // Action button
            if !isFiltered {
                Button(action: onAddModule) {
                    HStack {
                        Image(systemName: "plus")
                        Text("Add Module")
                    }
                    .font(.headline)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(Color.blue)
                    .cornerRadius(25)
                }
                .buttonStyle(.plain)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 60)
    }
}

#Preview {
    VStack(spacing: 40) {
        EmptyModulesState(isFiltered: false) {
            print("Add module tapped")
        }
        
        EmptyModulesState(isFiltered: true) {
            print("Add module tapped")
        }
    }
    .background(Color(.systemGroupedBackground))
}

