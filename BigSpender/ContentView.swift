import SwiftUI
import SwiftData
import YASU

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    @State private var textFieldString = ""
    @State private var marketableItems: [Int]?

    var body: some View {
        NavigationSplitView {
            List {
                HStack{
                    
                    TextField("itemID", text: $textFieldString, prompt: Text("itemID"))
                        .textFieldStyle(.roundedBorder)
                        .onSubmit() {
                            addItem()
                        }
                    Button("add") {
                        addItem()
                    }
                }
                
                ForEach(items) { item in
                    NavigationLink {
                        MarketSpenderView(itemID: item.itemID)
                    } label: {
                        ItemLabel(itemId: item.itemID)
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .navigationSplitViewColumnWidth(min: 180, ideal: 200)
        } detail: {
            Text("Select an item")
        }
        .task {
            marketableItems = await loadData(Endpoints.marketableItems)
        }
    }

    private func addItem() {
        withAnimation {
            if let itemID = Int(textFieldString){
                if let marketableItems = marketableItems{
                    if marketableItems.contains(itemID){
                        
                        
                        let newItem = Item(itemID: itemID)
                        modelContext.insert(newItem)
                    }
                }
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
