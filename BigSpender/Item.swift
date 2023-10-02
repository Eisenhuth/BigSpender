import Foundation
import SwiftData

@Model
final class Item {
    @Attribute(.unique)
    var itemID: Int
    
    init(itemID: Int) {
        self.itemID = itemID
    }
}
