import XCTest
import Combine
@testable import NetworkModule

final class NetworkModuleTests: XCTestCase {

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

    func testURLSessionGet() throws {
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

    func testAlamofireGet() throws {
        let expectation = XCTestExpectation()
        var message = ""
        MockService
            .jsonplaceholderUser()
            .done {
                message = $0.hello
                expectation.fulfill()
            }
            .cauterize()

        wait(for: [expectation], timeout: 5)
        XCTAssertEqual(message, "world")
    }
}
