//
//  JiraMurallerApp.swift
//  JiraMuraller
//
//  Created by Stacey Vetzal on 2024-09-20.
//

import SwiftUI
import SwiftData

@main
struct JiraMurallerApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            ServerConfiguration.self,
            JiraQuery.self,
            JiraIssue.self,
        ])
        let modelConfiguration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false
        )

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
