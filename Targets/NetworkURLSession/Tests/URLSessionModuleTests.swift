import XCTest
import Combine
@testable import NetworkURLSession

final class URLSessionModuleTests: XCTestCase {
    var cancellables: Set<AnyCancellable> = .init()

    var server: MyLocalServer!

    override func setUpWithError() throws {
        server = MyLocalServer()
        server.startServer()
        server.configureServer()
    }

    func testGetMethod() {
        let expectation = XCTestExpectation()
        var message = ""
        MockService
            .jsonplaceholderUser()
            .sink(receiveCompletion: { _ in },
                  receiveValue: { model in
                message = model.hello
                expectation.fulfill()
            })
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 3)
        XCTAssertEqual(message, "world")
    }
}
