import SwiftUI
import Foundation

extension Color {
    static let cardBackground = Color(.systemBackground)
    static let cardShadow = Color.black.opacity(0.1)
    
    static func moduleColor(for colorName: String) -> Color {
        switch colorName {
        case "blue": return .blue
        case "green": return .green
        case "orange": return .orange
        case "purple": return .purple
        case "red": return .red
        case "teal": return .teal
        case "pink": return .pink
        case "indigo": return .indigo
        default: return .blue
        }
    }
}

extension Date {
    var relativeString: String {
        let days = Calendar.current.dateComponents([.day], from: Date(), to: self).day ?? 0
        if days == 0 { return "Today" }
        if days == 1 { return "Tomorrow" }
        if days > 0 {
            return "In \(days) day\(days == 1 ? "" : "s")"
        } else {
            return "\(-days) day\(days == -1 ? "" : "s") ago"
        }
    }
}

extension Double {
    func rounded(to decimals: Int) -> Double {
        let multiplier = pow(10.0, Double(decimals))
        return (self * multiplier).rounded() / multiplier
    }
    
    var percentageString: String {
        "\(Int(self))%"
    }
    
    var gpaString: String {
        String(format: "%.2f", self)
    }
}
