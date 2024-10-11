import Foundation
import SwiftUI
import SwiftData

struct IssuesListView: View {
    var server: ServerConfiguration
    @ObservedObject var query: JiraQuery
    @Environment(\.modelContext) private var context

    @State private var isLoading = false

    var body: some View {
        VStack {
            VStack {
                HStack {
                    Text("Name")
                    TextField("Name", text: $query.name)
                }
                HStack {
                    Text("JQL Query")
                    TextField("JQL", text: $query.jql)
                    Button(action: searchButtonWasPressed) {
                        Text("Search")
                    }
                    .disabled(isLoading)
                }
            }
            .padding([.vertical, .horizontal])
            Table(query.issues) {
                TableColumn("Key", value: \.key)
                TableColumn("Summary", value: \.summary)
                TableColumn("URL", value: \.url.absoluteString)
            }
            .padding([.horizontal])
            Button(action: copyToClipboard) {
                Text("Copy Issues to Clipboard")
            }
            .padding(.vertical)
            .disabled(isLoading)
        }
        .navigationTitle(query.name)
    }

    func copyToClipboard() {
        var widgets: [[String: Any]] = []
                
        let margin = 23
        let width = 138
        let height = 138
        let rowlength = 3
        var xpos = 0
        var ypos = 0
 
        for issue in query.issues {
            var backgroundColor: String
            switch issue.type.lowercased() {
            case "epic":
                backgroundColor = "#8751da" // JIRA Epic purple
            case "story":
                backgroundColor = "#79b84f" // JIRA Story green
            default:
                backgroundColor = "#fcfe7d" // Default color (yellow)
            }
            
            let widget: [String: Any] = [
                "height": height,
                "width": width,
                "x": xpos,
                "y": ypos,
                "properties": [
                    "backgroundColor": backgroundColor,
                    "htmlText": "<div><b>\(issue.key)</b><br>\(issue.summary)</div>",
                    "link": [
                        "url": issue.url.absoluteString,
                        "source": "url"
                    ],
                    "textType": "realNote",
                    "textAlign": "center",
                    "fontFamily": "proxima-nova",
                ],
                "type": "murally.widget.TextWidget"
            ]
            widgets.append(widget)
            xpos += width + margin
            if xpos >= (width+margin)*rowlength {
                xpos = 0
                ypos += height + margin
            }
        }

        let dictionary: [String: Any] = [
            "widgets": widgets
        ]

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dictionary, options: [])
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                if let b64string = jsonString.data(using: .utf8)?.base64EncodedString() {
                    let htmlString = "<meta charset='utf-8'><murally hiddenContent=\"mly://\(b64string)\"></murally><table style=\"width: 99%;\"><tr><td style=\"padding: 0;\"><a href=\"https://stacey.vetzal.com/\"><div><span>Please visit </span><i><span>Stacey's Blog</span></i><span> for </span><b><span>fun</span></b><span> content!</span></div></a></td></tr></table>"
                    let pasteboard = NSPasteboard.general
                    pasteboard.clearContents()

                    if let htmlData = htmlString.data(using: .utf8) {
                        pasteboard.setData(htmlData, forType: .html)
                    }
                }
            }
        } catch {
            print("Error doing stuff: \(error)")
        }
    }
    
    func searchButtonWasPressed() {
        isLoading = true // Start loading
        
        Task {
            do {
                let jiraGateway = JiraGateway(server: server)
                let issuesDTO = try await jiraGateway.fetchIssues(jql: query.jql)
                
                await MainActor.run {
                    query.issues.removeAll() // Clear existing issues

                    // Create new JiraIssue instances and save them in the context
                    for issueDTO in issuesDTO {
                        let newIssue = JiraIssue(
                            key: issueDTO.key,
                            summary: issueDTO.fields.summary,
                            type: issueDTO.fields.issuetype.name,
                            url: URL(string: "https://\(server.host)/browse/\(issueDTO.key)")!
                        )
                        
                        context.insert(newIssue) // Insert into SwiftData context
                        query.issues.append(newIssue) // Add to query's issues
                    }

                    // Save the context to persist the data
                    do {
                        try context.save()
                    } catch {
                        print("Failed to save issues: \(error)")
                    }
                }
            } catch {
                print("Failed to download issues: \(error)")
            }
            isLoading = false // Stop loading
        }
    }
}
