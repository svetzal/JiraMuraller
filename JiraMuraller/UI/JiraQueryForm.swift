import SwiftUI

struct JiraQueryForm: View {
    @Binding var query: JiraQuery
    
    var body: some View {
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
    }
    
    func searchButtonWasPressed() {
    }
}

