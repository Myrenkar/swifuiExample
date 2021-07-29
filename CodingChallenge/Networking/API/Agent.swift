import Foundation
import Combine

protocol NetworkRunnerProtocol {
    func run<T: Decodable>(_ request: URLRequest) -> AnyPublisher<T, Error>
}

struct Agent: NetworkRunnerProtocol {
    func run<T: Decodable>(_ request: URLRequest) -> AnyPublisher<T, Error> {
        let snakeCaseDecode = JSONDecoder()
        snakeCaseDecode.keyDecodingStrategy = .convertFromSnakeCase
        snakeCaseDecode.dateDecodingStrategy = .iso8601

        return URLSession.shared
            .dataTaskPublisher(for: request)
            .map { $0.data }
            .handleEvents(receiveOutput: { print(NSString(data: $0, encoding: String.Encoding.utf8.rawValue) ?? "") })
            .decode(type: T.self, decoder: snakeCaseDecode)
            .mapError({ err in
                return err
            })
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
