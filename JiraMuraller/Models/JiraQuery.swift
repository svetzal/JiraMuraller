import Foundation
import SwiftData

@Model
final class JiraQuery: ObservableObject, Identifiable, Hashable {
    @Attribute(.unique) var id: UUID
    var name: String
    var jql: String
    @Relationship(deleteRule: .cascade) var issues: [JiraIssue]

    init(name: String, jql: String) {
        self.id = UUID()
        self.name = name
        self.jql = jql
        self.issues = []
    }
    
    // MARK: - Hashable Conformance
    static func == (lhs: JiraQuery, rhs: JiraQuery) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
