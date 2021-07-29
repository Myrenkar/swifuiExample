import Combine
import Foundation

enum ShiftsAPI {
    private static let base = URL(string: "https://dev.shiftkey.com/api/v2/")!
    private static let agent = Agent()

    static func shifts(week: Int) -> AnyPublisher<ShiftsResponse, Error> {
        let request = URLComponents(url: base.appendingPathComponent("available_shifts"), resolvingAgainstBaseURL: true)?
            .addingQuery(key: "address", value: "Dallas")
            .addingQuery(key: "type", value: "week")
            .addingQuery(key: "start", value: ShiftsAPI.week(for: week))
            .request
        return agent.run(request!)
    }

    static func week(for numberOfWeeks: Int) -> String {
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

// MARK: - DTOs

struct ShiftsDTO: Codable {
    let date: String
    let shifts: [ShiftDTO]
}

struct ShiftDTO: Codable {
    let shiftId: Int
    let startTime: Date
    let endTime: Date
    let covid: Bool
    let shiftKind: String
    let facilityType: ShiftFacilityDetails
    let skill: ShiftFacilityDetails
    let localizedSpecialty: LocalizedSpeciality

    struct ShiftFacilityDetails: Codable {
        let name: String
        let color: String
    }

    struct LocalizedSpeciality: Codable {
        let name: String
        let specialty: ShiftFacilityDetails
    }
}

struct ShiftsResponse: Codable {
    let data: [ShiftsDTO]
}

/*
 Optional<DecodingError>
   ▿ some : DecodingError
     ▿ keyNotFound : 2 elements
       - .0 : CodingKeys(stringValue: "color", intValue: nil)
       ▿ .1 : Context
         ▿ codingPath : 5 elements
           - 0 : CodingKeys(stringValue: "data", intValue: nil)
           ▿ 1 : _JSONKey(stringValue: "Index 4", intValue: 4)
             - stringValue : "Index 4"
             ▿ intValue : Optional<Int>
               - some : 4
           - 2 : CodingKeys(stringValue: "shifts", intValue: nil)
           ▿ 3 : _JSONKey(stringValue: "Index 0", intValue: 0)
             - stringValue : "Index 0"
             ▿ intValue : Optional<Int>
               - some : 0
           - 4 : CodingKeys(stringValue: "localizedSpecialty", intValue: nil)
         - debugDescription : "No value associated with key CodingKeys(stringValue: \"color\", intValue: nil) (\"color\")."
         - underlyingError : nil

 (lldb)
 */
