import Foundation
import SwiftUI

struct ServerForm: View {
    @ObservedObject var server: ServerConfiguration
    
    var body: some View {
        Form {
            TextField("Server Name", text: $server.name)
            TextField("Hostname", text: $server.host)
            TextField("Username", text: $server.username)
            TextField("Personal Access Token", text: $server.token)
        }
        .padding(.all)
    }
}

#Preview {
    ServerForm(server: ServerConfiguration(name: "Server Name", host: "server.com", username: "username", token: "token123"))
}
