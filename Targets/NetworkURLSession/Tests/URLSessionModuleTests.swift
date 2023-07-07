import XCTest
import Combine
@testable import NetworkURLSession

final class URLSessionModuleTests: XCTestCase {
    var cancellables: Set<AnyCancellable> = .init()

    func testGetMethod() {
        let expectation = XCTestExpectation()
        var userId = -1
        MockService
            .jsonplaceholderUser()
            .sink(receiveCompletion: { _ in },
                  receiveValue: { model in
                userId = model.userId
                expectation.fulfill()
            })
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 3)
        XCTAssertEqual(userId, 1)
    }
}
