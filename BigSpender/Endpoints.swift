import Foundation

struct Endpoints {
    static let marketableItems = URL(string: "https://universalis.app/api/v2/marketable")!
    
    static func getXivItem(itemId: Int, nameOnly: Bool = false) -> URL{
        URL(string: "https://xivapi.com/item/\(itemId)/\(nameOnly ? "?columns=Name" : "")")!
    }
    
    static func getUniversalisItemHistory(_ world: String, _ itemId: Int, _ days: Int = 30, _ entriesToReturn: Int = 1800) -> URL{
        let day = 86400
        let entriesWithinSeconds = day * days
        
        return URL(string: "https://universalis.app/api/v2/history/\(world)/\(itemId)?entriesToReturn=\(entriesToReturn)&entriesWithinSeconds=\(entriesWithinSeconds)")!
    }
}
