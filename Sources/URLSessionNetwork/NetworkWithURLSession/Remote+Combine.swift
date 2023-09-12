import Foundation
import Combine

public extension Remote {

    func asPublisher() -> AnyPublisher<T, Error> {
        Deferred { () -> AnyPublisher<T, Error> in
            self.request()
        }.eraseToAnyPublisher()
    }

//    func asPublisher() -> AnyPublisher<T, Error> {
//        Deferred { () -> PassthroughSubject<T, Error> in
//            let subject = PassthroughSubject<T, Error>()
//            Task {
//                do {
//                    let value = try await self.request()
//                    await MainActor.run {
//                        subject.send(value)
//                        subject.send(completion: .finished)
//                    }
//                } catch {
//                    subject.send(completion: .failure(error))
//                }
//            }
//            return subject
//        }.eraseToAnyPublisher()
//    }

}
