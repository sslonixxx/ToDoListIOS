import Foundation

struct ItemModel: Identifiable, Codable {
    let id: Int?
    let description: String
    let isDone: Bool
    
    init(id: Int? = nil, description: String, isDone: Bool) {
        self.id = id
        self.description = description
        self.isDone = isDone
    }
    
    func updateCompletion() -> ItemModel {
        return ItemModel(id: id, description: description, isDone: !isDone)
    }
}
