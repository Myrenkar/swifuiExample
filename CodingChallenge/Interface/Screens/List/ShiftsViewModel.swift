import Foundation
import Combine

final class ShiftsViewModel: ObservableObject {
    @Published private(set) var state = State.idle
    @Published private(set) var currentPage = 0

    private(set) var items: [ListSection] = []
    private var bag = Set<AnyCancellable>()

    private let input = PassthroughSubject<Event, Never>()
    private let api: ShiftsAPIProtocol

    init(api: ShiftsAPIProtocol) {
        self.api = api

        Publishers.system(
            initial: state,
            reduce: reduce,
            scheduler: RunLoop.main,
            feedbacks: [
                whenLoadingInitial(page: 0),
                userInput(input: input.eraseToAnyPublisher())
            ]
        )
        .assign(to: \.state, on: self)
        .store(in: &bag)
    }

    deinit {
        bag.removeAll()
    }

    func send(event: Event) {
        input.send(event)
    }
}

// MARK: - Inner Types

extension ShiftsViewModel {
    enum State {
        case idle
        case loading(Int)
        case loaded([ListSection])
        case error(Error)
    }

    enum Event {
        case onAppear
        case onSelectShift(ListItem)
        case onShiftLoaded([ListSection])
        case onFailedToLoadShifts(Error)
        case scrolledToLast
    }

    struct ListSection: Identifiable, Equatable {
        let id: String
        let items: [ListItem]

        init(shift: ShiftsDTO) {
            id = shift.date
            items = shift.shifts.map { ListItem(shift: $0) }
        }
    }

    struct ListItem: Identifiable, Equatable {
        let id: Int
        let startTime: Date
        let endTime: Date
        let covid: Bool
        let shiftKind: String
        let skill: ShiftDTO.ShiftFacilityDetails
        let localizedSpecialty: ShiftDTO.LocalizedSpeciality

        init(shift: ShiftDTO) {
            id = shift.shiftId
            startTime = shift.startTime
            endTime = shift.endTime
            covid = shift.covid
            shiftKind = shift.shiftKind
            skill = shift.skill
            localizedSpecialty = shift.localizedSpecialty
        }

        static func == (lhs: ShiftsViewModel.ListItem, rhs: ShiftsViewModel.ListItem) -> Bool {
            return lhs.id == rhs.id
        }
    }
}

// MARK: - State Machine

extension ShiftsViewModel {
    func reduce(_ state: State, _ event: Event) -> State {
        switch state {
            case .idle:
                switch event {
                    case .onAppear:
                        return .loading(0)
                    default:
                        return state
                }
            case .loading:
                switch event {
                    case .onFailedToLoadShifts(let error):
                        return .error(error)
                    case .onShiftLoaded(let sections):
                        items += sections
                        return .loaded(items)
                    default:
                        return state
                }
            case .loaded:
                switch event {
                    case .scrolledToLast:
                        return .loading(currentPage + 1)
                    default:
                        return state
                }
            case .error:
                return state
        }
    }

    func whenLoadingInitial(page: Int) -> Feedback<State, Event> {
        Feedback { (state: State) -> AnyPublisher<Event, Never> in
            guard case .loading = state else { return Empty().eraseToAnyPublisher() }
            return self.api.shifts(week: page)
                .map { $0.data.map(ListSection.init) }
                .map(Event.onShiftLoaded)
                .catch { Just(Event.onFailedToLoadShifts($0)) }
                .eraseToAnyPublisher()
        }
    }

    func userInput(input: AnyPublisher<Event, Never>) -> Feedback<State, Event> {
        Feedback { _ in input }
    }
}
