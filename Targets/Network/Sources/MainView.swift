import SwiftUI
import NetworkAlamofire

public struct MainView: View {
    public init() {}

    public var body: some View {
        VStack {
            Text("Hello, Network Sample App!")
                .padding()
            Button("Use Alamofire With PromiseKit") {
                NetRequest<PostModel>.jsonplaceholderUser()
                    .done { model in
                        print("👍[Result]", model.title)
                    }
                    .catch { error in
                        print("❌[Error]")
                    }
            }
        }

    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
