//
//  ContentView.swift
//  JiraMuraller
//
//  Created by Stacey Vetzal on 2024-09-20.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var servers: [ServerConfiguration]

    @State private var selectedServer: UUID?
    @State private var selectedQuery: UUID?
    
    var body: some View {
        NavigationSplitView {
            Section("JIRA Servers") {
                List(selection: $selectedServer) {
                    ForEach(servers) { server in
                        Text(server.name)
                            .tag(server.id)
                    }
                    .onDelete(perform: deleteSelectedServerIndexes)
                }
                .navigationSplitViewColumnWidth(min: 180, ideal: 200)
                .navigationTitle("Servers")
                .toolbar {
                    ToolbarItem {
                        Button(action: addServer) {
                            Label("Add Server", systemImage: "plus")
                        }
                    }
                }
            }
        } content: {
            if let serverId = selectedServer {
                let server = servers.first(where: {$0.id == serverId})!
                QueriesListView(server: server, selectedQuery: $selectedQuery)
            } else {
                Text("Select a server.")
            }
        } detail: {
            if let serverId = selectedServer,
               let queryId = selectedQuery,
               let server = servers.first(where: {$0.id == serverId})
            {
                if let query = server.queries.first(where: {$0.id == queryId})
                {
                    IssuesListView(query: query)
                } else {
                    Text("Add a query.")
                }
            } else {
                Text("Select a query.")
            }
        }
    }

    private func addServer() {
        withAnimation {
            let newItem = ServerConfiguration(name: "svetzal", host: "svetzal.atlassian.net", username: "stacey@vetzal.com", token: "abc123")
            modelContext.insert(newItem)
            let newQuery = JiraQuery(name: "Query 1", jql: "empty jql")
            newItem.queries.append(newQuery)
        }
    }
    
    private func deleteSelectedServerIndexes(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(servers[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: ServerConfiguration.self, inMemory: true)
}
