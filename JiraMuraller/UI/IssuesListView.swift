import Foundation
import SwiftUI
import SwiftData

struct IssuesListView: View {
    @ObservedObject var query: JiraQuery
    @Environment(\.modelContext) private var context

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
        }
        .navigationTitle(query.name)
    }

    func copyToClipboard() {
    }
    
    func searchButtonWasPressed() {
        
    }
}
