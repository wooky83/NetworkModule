import XCTest
import RxSwift
@testable import RxNetworkKit

fileprivate struct Service {
    public static func rxAlamofireSuccess() -> Observable<SuccessModel> {
        Remote<SuccessModel>(url: "http://localhost:1234/api/v2/users").asObservable()
    }
}


final class RxNetworkTests: AsyncXCTestCase {

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
