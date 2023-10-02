import SwiftUI
import Charts

struct MarketSpenderView: View {
    var itemID: Int
    
    @State private var history: UniversalisHistory?
    var marketOptions = ["North-America", "Europe", "Oceania"]
    @State private var market = "Europe"
    @State private var filterByPrice = false
    @State private var minimumPrice = "10000000"
    @State private var chartPriceFilter = "1000"
    @State private var sortOrder = [
        KeyPathComparator(\HistoryEntry.buyerName),
        KeyPathComparator(\HistoryEntry.pricePerUnit),
        KeyPathComparator(\HistoryEntry.worldName),
        KeyPathComparator(\HistoryEntry.timestamp)
    ]
    
    var body: some View {
                
        let universalisUrl = URL(string: "https://universalis.app/api/v2/history/\(market)/\(itemID)\(filterByPrice ? ("?minSalePrice=\(minimumPrice)") : "")")!

        
        VStack(alignment: .leading){
            Picker("Region", selection: $market) {
                ForEach(marketOptions, id: \.self){
                    Text($0)
                }
            }
            .pickerStyle(.radioGroup)
            
            HStack{
                Toggle("minSalePrice", isOn: $filterByPrice)
                    .toggleStyle(.checkbox)
                
                TextField("", text: $minimumPrice)
                    .textFieldStyle(.roundedBorder)
                    .disabled(!filterByPrice)
                    .frame(width: 100)
            }
            Divider()
            
            HStack{
                Text("chart transactions above")
                TextField("", text: $chartPriceFilter)
                    .frame(width: 100)
                    .onChange(of: chartPriceFilter) { _ , newValue in
                        if Int(chartPriceFilter) == nil{
                            chartPriceFilter = "1000"
                        }
                    }
            }
            
            Divider()
            
            
            Text(universalisUrl.description)
                .foregroundStyle(.secondary)
                        
            if (history?.entries) != nil{
                Chart(history!.entries){entry in
                    if (entry.pricePerUnit * entry.quantity) > Int(chartPriceFilter) ?? 1{
                        BarMark(
                            x: .value("Name", entry.buyerName),
                            y: .value("Price", entry.pricePerUnit)
                        )
                        .foregroundStyle(by: .value("name", entry.buyerName))
                    }
                }
                .chartYAxis {
                    AxisMarks() {
                        let value = $0.as(Int.self)!
                        AxisValueLabel {
                            Text("\(value) gil")
                        }
                    }
                }
                .chartLegend(.hidden)
                .frame(height: 200)
                
                Table(history!.entries, sortOrder: $sortOrder){
                    TableColumn("Buyer", value: \.buyerName)
                    TableColumn("Price per Unit", value: \.pricePerUnit.description)
                    TableColumn("QTY", value: \.quantity.description)
                    TableColumn("Date", value: \.dateString)
                    TableColumn("World", value: \.worldName)
                }
                .onChange(of: sortOrder) { order, _ in
                    history!.entries.sort(using: order)
                }
                
                
            } else {
                ContentUnavailableView("no data", systemImage: "xmark", description: Text(universalisUrl.description))
            }
        }
        .padding()
        .onChange(of: universalisUrl) {
            Task {
                await history = loadData(universalisUrl)
            }
        }
        .onChange(of: minimumPrice){
            if minimumPrice.isEmpty {
                minimumPrice = "1"
            }
        }
        
        .task {
            await history = loadData(universalisUrl)
        }
    }
}

#Preview {
    MarketSpenderView(itemID: 4421)
        .frame(width: 600, height: 600)
}
