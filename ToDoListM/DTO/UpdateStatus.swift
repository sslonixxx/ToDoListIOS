import Foundation

struct UpdateStatusDto: Codable {
    let isDone: Bool
}

struct UpdateDescriptionDto: Codable {
    let description: String
}
