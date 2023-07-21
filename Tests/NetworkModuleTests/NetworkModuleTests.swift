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
            .sink(receiveCompletion: { completion in
                print("testURLSessionGet", completion)
            }, receiveValue: { model in
                print("testURLSessionGet", model)
                message = model.hello
                expectation.fulfill()
            })
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 5)
        XCTAssertEqual(message, "world")
    }

    func testURLSessionGetFail() throws {
        let expectation = XCTestExpectation()
        var networkError = NetworkError.httpError
        MockService
            .jsonplaceholderUserFail()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    networkError = error as? NetworkError ?? .httpError
                case .finished:()
                }
                expectation.fulfill()
            }, receiveValue: { model in
                print(model)
            })
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 5)
        if case .jsonDecodingError = networkError {
            XCTAssertTrue(true)
        } else {
            XCTFail()
        }
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

    func testLogger() throws {
        Log.info("Test Logger!!")
    }
}
