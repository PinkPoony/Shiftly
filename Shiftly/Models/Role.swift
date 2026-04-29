import Foundation
import SwiftData

enum Role: String, Codable, CaseIterable {
    case baker = "Пекарь"
    case cashier = "Кассир"
    
    var colorHex: String {
        switch self {
        case .baker: return "#f5a42a"
        case .cashier: return "#ed761a"
        }
    }
}
