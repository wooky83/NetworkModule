import XCTest
import PromiseKit
@testable import PromiseNetworkKit

fileprivate struct Service {

    public static func jsonplaceholderUser(_ param: [String: String]? = nil) -> Promise<SuccessModel> {
        NetworkTask<SuccessModel>(parameter: param).requestNetworkConnection("http://localhost:1234/api/v2/users")
    }
}


final class PromiseNetworkTests: AsyncXCTestCase {

    func testPromiseSuccess() async throws {
        let value: String = try await asynchronousTest { continuation in
            Service
                .jsonplaceholderUser()
                .done {
                    continuation.resume(returning: $0.hello)
                }
                .cauterize()
        }

        XCTAssertEqual(value, "world")
    }
}

