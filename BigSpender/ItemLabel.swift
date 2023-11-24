import SwiftUI
import YASU

struct ItemLabel: View {
    var itemId: Int
    @State private var xivItem: XivItem?
    
    var body: some View {
        Text(xivItem?.Name ?? itemId.description)
            .task {
                xivItem = await loadData(Endpoints.getXivItem(itemId: itemId, nameOnly: true))
            }
    }
}

#Preview {
    ItemLabel(itemId: 39727)
}
