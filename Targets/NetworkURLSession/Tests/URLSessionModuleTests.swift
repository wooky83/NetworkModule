import XCTest
import Combine
@testable import NetworkURLSession

final class URLSessionModuleTests: XCTestCase {
    var cancellables: Set<AnyCancellable> = .init()

    var server: MyLocalServer!

    override func setUpWithError() throws {
        try super.setUpWithError()
        server = MyLocalServer()
        server.startServer()
        server.configureServer()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        server = nil
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

        wait(for: [expectation], timeout: 5)
        XCTAssertEqual(message, "world")
    }
}
