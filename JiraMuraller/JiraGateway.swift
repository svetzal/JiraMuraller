import Foundation

class JiraGateway {
    private let server: ServerConfiguration

    init(server: ServerConfiguration) {
        self.server = server
    }
    
    func fetchIssues(jql: String) async throws -> [JiraIssueDTO] {
        let encodedQuery = jql.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let url = URL(string: "https://\(server.host)/rest/api/3/search?jql=\(encodedQuery)")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        // Set up basic user authentication
        let loginString = String(format: "%@:%@", server.username, server.token)
        let loginData = loginString.data(using: .utf8)!
        let base64LoginString = loginData.base64EncodedString()
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")

        // Perform the async HTTP request
        let (data, response) = try await URLSession.shared.data(for: request)

        // Check if response is a valid HTTP response
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }

        // Decode the JSON response
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let jiraResponse = try decoder.decode(JiraResponse.self, from: data)
        return jiraResponse.issues
    }
}

// Response structures for decoding the JIRA response
struct JiraResponse: Codable {
    var issues: [JiraIssueDTO]
}

struct JiraIssueDTO: Codable {
    var key: String
    var fields: Fields
    
    struct Fields: Codable {
        var summary: String
        var issuetype: IssueType
    }
    
    struct IssueType: Codable {
        var name: String
    }
}
