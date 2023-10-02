import Foundation

func loadData<T: Decodable>(_ url: URL) async -> T? {
    do{
        let (data, _) = try await URLSession.shared.data(from: url)
        let decoder = JSONDecoder()
        let decoded = try decoder.decode(T.self, from: data)
        
        return decoded
        
    } catch {
        print("error loading data\n\(url)\n\(error.localizedDescription)")
    }
    
    return nil
}
