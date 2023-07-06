import Foundation
import Combine

extension Remote {

    func asPublisher() -> AnyPublisher<T?, Error> {
        Deferred { () -> PassthroughSubject<T?, Error> in
            let subject = PassthroughSubject<T?, Error>()
            Task {
                do {
                    let value = try await self.requestNetworkConnection()
                    subject.send(value)
                    subject.send(completion: .finished)
                } catch {
                    subject.send(completion: .failure(error))
                }
            }
            return subject
        }.eraseToAnyPublisher()
    }

}
