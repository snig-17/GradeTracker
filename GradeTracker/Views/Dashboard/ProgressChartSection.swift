//
//  ProgressChartSection.swift
//  GradeTracker
//
//  Created by Snigdha Tiwari  on 26/08/2025.
//

import SwiftUI
import Charts

struct ProgressChartSection: View {
    let student: Student
    @State private var selectedTimeframe: ChartTimeframe = .semester
    
    var body: some View {
        VStack(spacing: 16) {
            // Header with timeframe picker
            HStack {
                HStack(spacing: 8) {
                    Image(systemName: "chart.xyaxis.line")
                        .foregroundStyle(.purple)
                        .font(.headline)
                    
                    Text("Grade Trends")
                        .font(.headline)
                        .fontWeight(.semibold)
                }
                
                Spacer()
                
                // Timeframe picker
                Picker("Timeframe", selection: $selectedTimeframe) {
                    ForEach(ChartTimeframe.allCases, id: \.self) { timeframe in
                        Text(timeframe.rawValue).tag(timeframe)
                    }
                }
                .pickerStyle(.segmented)
                .frame(width: 180)
            }
            
            // Chart content
            if chartData.isEmpty {
                EmptyChartView()
            } else {
                GradeProgressChart(
                    data: chartData,
                    systemType: student.systemType,
                    timeframe: selectedTimeframe
                )
                .frame(height: 200)
            }
        }
        .padding()
        .background(Color.cardBackground)
        .cornerRadius(16)
        .shadow(color: Color.cardShadow, radius: 8, x: 0, y: 4)
    }
    
    private var chartData: [GradeDataPoint] {
        switch selectedTimeframe {
        case .semester:
            return semesterData
        case .year:
            return yearlyData
        case .overall:
            return overallData
        }
    }
    
    private var semesterData: [GradeDataPoint] {
        guard let currentYear = student.academicYears.first(where: { $0.isActive }) else { return [] }
        
        return currentYear.modules.compactMap { module in
            guard module.finalGrade > 0 else { return nil }
            
            return GradeDataPoint(
                date: Date(), // Simplified - in real app, track completion dates
                grade: module.finalGrade,
                label: module.code
            )
        }
    }
    
    private var yearlyData: [GradeDataPoint] {
        return student.academicYears.compactMap { year in
            guard year.yearGPA > 0 else { return nil }
            
            return GradeDataPoint(
                date: year.startDate,
                grade: year.yearGPA,
                label: year.name
            )
        }.sorted { $0.date < $1.date }
    }
    
    private var overallData: [GradeDataPoint] {
        return student.academicYears.compactMap { year in
            guard year.yearGPA > 0 else { return nil }
            
            return GradeDataPoint(
                date: year.endDate,
                grade: student.overallGPA, // Cumulative GPA
                label: year.name
            )
        }.sorted { $0.date < $1.date }
    }
}

struct GradeDataPoint: Identifiable, Equatable {
    let id = UUID()
    let date: Date
    let grade: Double
    let label: String
    
    static func == (lhs: GradeDataPoint, rhs: GradeDataPoint) -> Bool {
            return lhs.id == rhs.id &&
                   lhs.date == rhs.date &&
                   lhs.grade == rhs.grade &&
                   lhs.label == rhs.label
        }
}

enum ChartTimeframe: String, CaseIterable {
    case semester = "Semester"
    case year = "Yearly"
    case overall = "Overall"
}

struct GradeProgressChart: View {
    let data: [GradeDataPoint]
    let systemType: GradingSystem
    let timeframe: ChartTimeframe
    
    var body: some View {
        Chart(data) { dataPoint in
            LineMark(
                x: .value("Time", dataPoint.date),
                y: .value("Grade", dataPoint.grade)
            )
            .foregroundStyle(chartColor)
            .lineStyle(StrokeStyle(lineWidth: 3, lineCap: .round))
            .symbol(Circle().strokeBorder(lineWidth: 2))
            .symbolSize(60)
            
            AreaMark(
                x: .value("Time", dataPoint.date),
                y: .value("Grade", dataPoint.grade)
            )
            .foregroundStyle(
                LinearGradient(
                    colors: [chartColor.opacity(0.3), chartColor.opacity(0.05)],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
        }
        .chartYAxis {
            AxisMarks(position: .leading) { _ in
                AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5))
                    .foregroundStyle(.secondary.opacity(0.3))
                AxisValueLabel()
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
        .chartXAxis {
            AxisMarks { _ in
                AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5))
                    .foregroundStyle(.secondary.opacity(0.3))
                AxisValueLabel(format: .dateTime.month(.abbreviated))
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
        .chartYScale(domain: yAxisDomain)
        .animation(.easeInOut(duration: 0.5), value: data)
    }
    
    private var chartColor: Color {
        switch systemType {
        case .uk:
            return .purple
        case .us:
            return .blue
        }
    }
    
    private var yAxisDomain: ClosedRange<Double> {
        switch systemType {
        case .uk:
            return 0...100
        case .us:
            return 0...4
        }
    }
}

struct EmptyChartView: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "chart.line.uptrend.xyaxis")
                .font(.system(size: 40))
                .foregroundStyle(.secondary)
            
            Text("No grade data yet")
                .font(.headline)
                .foregroundStyle(.primary)
            
            Text("Complete some assessments to see your progress trends")
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(height: 150)
    }
}

#Preview {
    ProgressChartSection(student: Student.sampleStudent)
        .padding()
        .background(Color(.systemGroupedBackground))
}
