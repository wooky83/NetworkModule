import XCTest
import RxSwift
@testable import RxNetworkKit

fileprivate struct Service {
    public static func rxAlamofireSuccess() -> Observable<SuccessModel> {
        Remote<SuccessModel>(url: "http://localhost:1234/api/v2/users").asObservable()
    }

    struct SuccessModel: Codable {
        let hello: String
    }
}


final class RxSwiftNetworkTests: CommonTestCase {

    private let disposeBag = DisposeBag()

    func testRxAlamofireSuccess() async throws {
        let value: String = try await asynchronousTest { continuation in
            Service
                .rxAlamofireSuccess()
                .subscribe(onNext: { model in
                    continuation.resume(returning: model.hello)
                })
                .disposed(by: self.disposeBag)
        }

        XCTAssertEqual(value, "world")
    }
}

public class AsyncXCTestCase: XCTestCase {
    func asynchronousTest<T>(_ closure: @escaping (CheckedContinuation<T, Error>) -> ()) async throws -> T {
        try await withCheckedThrowingContinuation { continuation in
            closure(continuation)
        }
    }
}

public class CommonTestCase: AsyncXCTestCase {
    var server: MyLocalServer!

    public override func setUpWithError() throws {
        try super.setUpWithError()
        server = MyLocalServer()
        server.startServer()
        server.configureServer()
    }

    public override func tearDownWithError() throws {
        try super.tearDownWithError()
        server = nil
    }
}
