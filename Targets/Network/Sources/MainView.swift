import SwiftUI
import NetworkAlamofire
import NetworkURLSession
import Combine

public struct MainView: View {
    @State
    var cancellables: Set<AnyCancellable> = .init()

    public init() {}

    public var body: some View {
        VStack {
            Spacer()
            Text("Hello, Network Sample App!")
                .padding()
            Spacer()
            Button("Use Alamofire With PromiseKit") {
                HomeService
                    .jsonplaceholderUser()
                    .done { model in
                        print("👍[Result]", model.title)
                    }
                    .catch { error in
                        print("❌[Error]")
                    }
            }
            Spacer()
            Button("Use URLSession With Combine") {
                MainService
                    .jsonplaceholderUser()
                    .sink(receiveCompletion: {
                        print("completion: \($0)")
                    }, receiveValue: { model in
                        print("👍[Result]", model.body)
                    })
                    .store(in: &cancellables)

            }
            Spacer()
        }

    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
