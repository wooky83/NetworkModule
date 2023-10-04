import XCTest
import Combine
@testable import CombineNetworkKit

fileprivate struct Service {

    public static func jsonplaceholderUser(_ param: [String: String]? = nil) -> AnyPublisher<SuccessModel, Error> {
        Remote<SuccessModel>(url: "http://localhost:1234/api/v2/users", parameter: param)
            .asPublisher()
    }

    public static func jsonplaceholderUserFail() -> AnyPublisher<FailModel, Error> {
        Remote<FailModel>(url: "http://localhost:1234/api/v2/users")
            .asPublisher()
    }
}


final class CombineNetworkTests: AsyncXCTestCase {

    private var cancellables: Set<AnyCancellable> = .init()

    func testURLSessionGet() async throws {

        let value: String = try await asynchronousTest { continuation in
            Service
                .jsonplaceholderUser()
                .sink(receiveCompletion: { completion in
                    print("testURLSessionGet", completion)
                }, receiveValue: { model in
                    print("testURLSessionGet", model)
                    continuation.resume(returning: model.hello)
                })
                .store(in: &self.cancellables)
        }

        XCTAssertEqual(value, "world")
    }

    func testURLSessionGetFail() async throws {

        let value: NetworkError = try await asynchronousTest { continuation in
            Service
                .jsonplaceholderUserFail()
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error):
                        let networkError = error as? NetworkError ?? .httpError
                        continuation.resume(returning: networkError)
                    case .finished:()
                        continuation.resume(throwing: NSError())
                    }
                }, receiveValue: { model in
                    print(model)
                })
                .store(in: &self.cancellables)
        }

        if case .jsonDecodingError = value {
            XCTAssertTrue(true)
        } else {
            XCTFail()
        }

    }

}

