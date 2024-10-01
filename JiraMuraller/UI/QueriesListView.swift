import SwiftUI
import SwiftData

struct QueriesListView: View {
    var server: ServerConfiguration
    @Binding var selectedQuery: UUID?
    @Environment(\.modelContext) private var context

    var body: some View {
        List(selection: $selectedQuery) {
            ForEach(server.queries) { query in
                Text(query.name)
                    .tag(query.id)
            }
        }
        .navigationTitle(server.name)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(action: addQuery) {
                    Label("Add Query", systemImage: "plus")
                }
            }
            ToolbarItem(placement: .destructiveAction) {
                Button(action: deleteQuery) {
                    Label("Delete Query", systemImage: "trash")
                }
            }
        }
    }

    func addQuery() {
        let newQuery = JiraQuery(name: "New Query", jql: "jql goes here")
        server.queries.append(newQuery)
    }
    
    func deleteQuery() {
        server.queries.removeAll(where: {$0.id == selectedQuery})
    }
}
