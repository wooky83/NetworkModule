import XCTest

public class CommonTestCase: XCTestCase {
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

public class AsyncXCTestCase: CommonTestCase {
    @discardableResult
    func asynchronousTest<T>(_ closure: @escaping (CheckedContinuation<T, Error>) -> ()) async throws -> T {
        try await withCheckedThrowingContinuation { continuation in
            closure(continuation)
        }
    }
}
