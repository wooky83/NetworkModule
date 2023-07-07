import Foundation
import Swifter

class MyLocalServer {
    private var server = HttpServer()

    func startServer() {
        do {
            try server.start(1234)
            print("Server Status : \(server.state)")
        } catch {
            print("Server Start Error : \(error)")
        }
    }

    func configureServer() {
        server["/api/v2/users"] = { request in
            HttpResponse.ok(.text(
                """
                { "hello": "world" }
                """
            ))
        }
    }
}
