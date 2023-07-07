import Foundation
import XCTest
@testable import NetworkAlamofire

final class AlamofireModuleTests: XCTestCase {
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
            .done {
                message = $0.hello
                expectation.fulfill()
            }
            .cauterize()

        wait(for: [expectation], timeout: 5)
        XCTAssertEqual(message, "world")
    }
}
