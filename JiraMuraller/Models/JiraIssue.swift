import Foundation
import SwiftData

@Model
final class JiraIssue: Identifiable, Hashable {
    @Attribute(.unique) var id: UUID
    var key: String
    var summary: String
    var type: String
    var url: URL

    init(key: String, summary: String, type: String, url: URL) {
        self.id = UUID()
        self.key = key
        self.summary = summary
        self.type = type
        self.url = url
    }
    
    // MARK: - Hashable Conformance
    static func == (lhs: JiraIssue, rhs: JiraIssue) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
