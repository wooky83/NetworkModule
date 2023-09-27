import XCTest
import Combine
import RxSwift
@testable import AlamofireNetwork
@testable import URLSessionNetwork
@testable import RxNetwork

final class NetworkModuleTests: XCTestCase {

    private var cancellables: Set<AnyCancellable> = .init()
    private let disposeBag = DisposeBag()

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
        var networkError = URLSessionNetwork.NetworkError.httpError
        MockService
            .jsonplaceholderUserFail()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    networkError = error as? URLSessionNetwork.NetworkError ?? .httpError
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

    //TODO Test Case 나누기
    func testRxAlamofireSuccess() throws {
        let expectation = XCTestExpectation()
        var message = ""
        MockService
            .rxAlamofireSuccess()
            .subscribe(onNext: { model in
                message = model.hello
                expectation.fulfill()
            })
            .disposed(by: disposeBag)

        wait(for: [expectation], timeout: 5)
        XCTAssertEqual(message, "world")
    }
}
