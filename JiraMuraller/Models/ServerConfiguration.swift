import Foundation
import SwiftData

@Model
final class ServerConfiguration: Identifiable, Hashable {
    @Attribute(.unique) var id: UUID
    var name: String
    var host: String
    var username: String
    var token: String
    @Relationship(deleteRule: .cascade) var queries: [JiraQuery]

    init(name: String, host: String, username: String, token: String) {
        self.id = UUID()
        self.name = name
        self.host = host
        self.username = username
        self.token = token
        self.queries = []
    }
    
    // MARK: - Hashable Conformance
    static func == (lhs: ServerConfiguration, rhs: ServerConfiguration) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
