import XCTest
import RxSwift
import Alamofire
@testable import RxNetworkKit

fileprivate struct Service {
    public static func rxAlamofireSuccess() -> Observable<SuccessModel> {
        Remote<SuccessModel>(url: "http://localhost:1234/api/v2/users")
            .asObservable()
    }

    public static func rxAlamofireFail() -> Observable<FailModel> {
        Remote<FailModel>(url: "http://localhost:1234/api/v2/users")
            .asObservable()
    }

    public static func rxAlamofireHttpStatusFail() -> Observable<FailModel> {
        Remote<FailModel>(url: "http://localhost:1234/api/v2/status/fail")
            .asObservable()
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

    func testRxAlamofireFail() async throws {
        do {
            try await asynchronousTest { continuation in
                Service
                    .rxAlamofireFail()
                    .subscribe(onNext: { model in
                        continuation.resume(returning: model.world)
                    }, onError: { error in
                        continuation.resume(throwing: error)
                    })
                    .disposed(by: self.disposeBag)
            }
        } catch DecodingError.keyNotFound(let key, _) {
            XCTAssertEqual(key.stringValue, "world")
        }
    }

    func testRxAlamofireStatusFail() async throws {
        do {
            try await asynchronousTest { continuation in
                Service
                    .rxAlamofireHttpStatusFail()
                    .subscribe(onNext: { model in
                        continuation.resume(returning: model.world)
                    }, onError: { error in
                        continuation.resume(throwing: error)
                    })
                    .disposed(by: self.disposeBag)
            }
        } catch AFError.responseValidationFailed(reason: let reason) {
            if case .unacceptableStatusCode(code: 500) = reason {
                XCTAssertTrue(true)
            } else {
                XCTAssertTrue(false)
            }
        }
    }
}
