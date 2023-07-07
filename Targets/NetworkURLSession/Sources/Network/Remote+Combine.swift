import Foundation
import Combine

extension Remote {

    public func asPublisher() -> AnyPublisher<T?, Error> {
        Deferred { () -> PassthroughSubject<T?, Error> in
            let subject = PassthroughSubject<T?, Error>()
            Task {
                do {
                    let value = try await self.request()
                    subject.send(value)
                    subject.send(completion: .finished)
                } catch {
                    subject.send(completion: .failure(error))
                }
            }
            return subject
        }.eraseToAnyPublisher()
    }

    public func asUnwrapPublisher() -> AnyPublisher<T, Error> {
        asPublisher()
            .tryMap {
                guard let response = $0 else { throw NetworkError.typeCastingError }
                return response
            }
            .eraseToAnyPublisher()
    }

}
