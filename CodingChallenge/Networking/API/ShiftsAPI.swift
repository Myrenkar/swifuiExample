import Combine
import Foundation

enum ShiftsAPIError: Error {
    case badRequest
}

protocol ShiftsAPIProtocol {
    func shifts(week: Int) -> AnyPublisher<ShiftsResponse, Error>
}

final class ShiftsAPI: ShiftsAPIProtocol {
    private let base = URL(string: "https://dev.shiftkey.com/api/v2/")!
    private let agent: NetworkRunnerProtocol

    init(agent: NetworkRunnerProtocol) {
        self.agent = agent
    }

    // MARK: - ShiftsAPIProtocol

    func shifts(week: Int) -> AnyPublisher<ShiftsResponse, Error> {
        let request = URLComponents(url: base.appendingPathComponent("available_shifts"), resolvingAgainstBaseURL: true)?
            .addingQuery(key: "address", value: "Dallas")
            .addingQuery(key: "type", value: "week")
            .addingQuery(key: "start", value: weekString(for: week))
            .request
        guard let request = request else {
            return Fail(error: ShiftsAPIError.badRequest).eraseToAnyPublisher()
        }

        return agent.run(request)
    }

    func weekString(for numberOfWeeks: Int) -> String {
        let dateFormatter = DateFormatter()
        let currentDate = Date()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        guard let newWeek = Calendar.current.date(byAdding: .day, value: numberOfWeeks * 7, to: currentDate) else { return dateFormatter.string(from: currentDate)
        }
        return dateFormatter.string(from: newWeek)
    }
}

private extension URLComponents {
    func addingQuery(key: String, value: String) -> URLComponents {
        var copy = self
        var quertItemsCopy = copy.queryItems ?? []
        quertItemsCopy.append(URLQueryItem(name: key, value: value))
        copy.queryItems = quertItemsCopy
        return copy
    }

    var request: URLRequest? {
        url.map { URLRequest.init(url: $0) }
    }
}
