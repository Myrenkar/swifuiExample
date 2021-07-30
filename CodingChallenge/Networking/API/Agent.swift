import Foundation
import Combine

protocol NetworkRunnerProtocol {
    func run<T: Decodable>(_ request: URLRequest) -> AnyPublisher<T, Error>
}

final class Agent: NetworkRunnerProtocol {
    func run<T: Decodable>(_ request: URLRequest) -> AnyPublisher<T, Error> {
        let snakeCaseDecode = JSONDecoder()
        snakeCaseDecode.keyDecodingStrategy = .convertFromSnakeCase
        snakeCaseDecode.dateDecodingStrategy = .iso8601

        return URLSession.shared
            .dataTaskPublisher(for: request)
            .map { $0.data }
            .handleEvents(receiveOutput: {
                #if DEBUG
                print(NSString(data: $0, encoding: String.Encoding.utf8.rawValue) ?? "")
                #endif
            })
            .decode(type: T.self, decoder: snakeCaseDecode)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
