import Foundation

struct UniversalisHistory: Codable {
    let itemID: Int
    let lastUploadTime: Int
    var entries: [HistoryEntry]
    let regionName: String
}

struct HistoryEntry: Codable, Identifiable {    
    let hq: Bool
    let pricePerUnit: Int
    let quantity: Int
    let buyerName: String
    let onMannequin: Bool
    let timestamp: Int
    let worldName: String
    let worldID: Int
    
    let id = UUID()
    var dateString: String {
        Date(timeIntervalSince1970: TimeInterval(timestamp)).formatted(date: .numeric, time: .shortened)
    }
}
