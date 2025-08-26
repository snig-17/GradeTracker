//
//  SectionHeaderView.swift
//  GradeTracker
//
//  Created by Snigdha Tiwari  on 26/08/2025.
//

import SwiftUI

struct SectionHeaderView: View {
    let title: String
    let icon: String
    let badge: Int?
    let action: (() -> Void)?
    
    init(title: String, icon: String, badge: Int? = nil, action: (() -> Void)? = nil) {
        self.title = title
        self.icon = icon
        self.badge = badge
        self.action = action
    }
    
    var body: some View {
        HStack {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .foregroundStyle(.blue)
                    .font(.headline)
                
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)
                
                if let badge = badge, badge > 0 {
                    BadgeView(count: badge)
                }
            }
            
            Spacer()
            
            if let action = action {
                Button(action: action) {
                    Image(systemName: "ellipsis.circle")
                        .foregroundStyle(.secondary)
                        .font(.title3)
                }
                .buttonStyle(.plain)
            }
        }
    }
}

struct BadgeView: View {
    let count: Int
    
    var body: some View {
        Text("\(count)")
            .font(.caption2)
            .fontWeight(.semibold)
            .foregroundStyle(.white)
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(.red)
            .cornerRadius(8)
    }
}

#Preview {
    VStack(spacing: 20) {
        SectionHeaderView(
            title: "Current Modules",
            icon: "books.vertical",
            badge: 5,
            action: { print("Tapped") }
        )
        
        SectionHeaderView(
            title: "Grade Trends",
            icon: "chart.xyaxis.line"
        )
        
        SectionHeaderView(
            title: "Upcoming Assessments",
            icon: "clock",
            badge: 12
        )
    }
    .padding()
    .background(Color(.systemGroupedBackground))
}

