import Foundation
import XCTest
@testable import NetworkAlamofire

final class AlamofireModuleTests: XCTestCase {
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
            .done {
                message = $0.hello
                expectation.fulfill()
            }
            .cauterize()

        wait(for: [expectation], timeout: 3)
        XCTAssertEqual(message, "world")
    }
}
