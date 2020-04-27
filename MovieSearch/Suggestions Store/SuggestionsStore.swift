import Foundation

class SuggestionsStore {
    
    static let shared = SuggestionsStore()
    
    private let PersisitanceKey = "SuggestionsStorePersisitanceKey"
    private let maxElementsCount = 10
    private init() {}
    
    /**
     Save the new search term in user defaults, remove dublicate if exist, insert the new item at first index
     */
    func save(term: String) {
        guard let savedItems = load() else {
            save(terms: [term])
            return
        }
        var items = savedItems
        if items.count >= maxElementsCount {
            _ = items.removeLast()
        }
        items.removeAll(where: { $0 == term})
        items.insert(term, at: 0)
        save(terms: items)
    }
    
    func load() -> [String]? {
        guard let encoded = UserDefaults.standard.object(forKey: PersisitanceKey) as? Data else { return []
        }
        return try? PropertyListDecoder().decode([String].self, from: encoded)
    }
    
    private func save(terms: [String]) {
        try? UserDefaults.standard.set(PropertyListEncoder().encode(terms), forKey: PersisitanceKey)
    }
    
}
