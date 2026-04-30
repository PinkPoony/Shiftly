import Foundation
import SwiftData

enum Role: String, Codable, CaseIterable {
    case baker = "Пекарь"
    case cashier = "Кассир"
    
    var colorHex: String {
        switch self {
        case .baker: return "#fcc11c"
        case .cashier: return "#ed761a"
        }
    }
}
