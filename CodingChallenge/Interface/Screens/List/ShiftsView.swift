import SwiftUI

struct ShiftsView: View {
    @ObservedObject var viewModel: ShiftsViewModel

    var body: some View {
        NavigationView {
            content
                .navigationBarTitle("Shifts")
        }
        .onAppear { self.viewModel.send(event: .onAppear) }
    }


    private var content: some View {
        switch viewModel.state {
            case .idle:
                return Color.clear.eraseToAnyView()
            case .loading:
                return Spinner(isAnimating: true, style: .large).eraseToAnyView()
            case .error(let error):
                return Text(error.localizedDescription).eraseToAnyView()
            case .loaded(let shifts):
                return list(of: shifts).eraseToAnyView()
        }
    }

    private func list(of shifts: [ShiftsViewModel.ListSection]) -> some View {
        return List {
            ForEach(shifts) { section in
                Section(header: Text(section.id)) {
                    ForEach(section.items, id: \.id) { item in
                        ShiftsItemView(shift: item).onAppear {
                            if shifts.last == section, shifts.last?.items.last == item  {
                                viewModel.send(event: .scrolledToLast)
                            }
                        }
                    }
                }
            }
        }.listStyle(GroupedListStyle())
    }
}

struct ShiftsItemView: View {
    @State private var showingSheet = false

    private var formatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, h:mm"
        return formatter
    }

    let shift: ShiftsViewModel.ListItem

    var body: some View {
        VStack(alignment: .leading) {
            title
            time
            HStack(alignment: .firstTextBaseline) {
                badge(for: shift.skill)
                badge(for: shift.localizedSpecialty.specialty)
            }
        }
        .onTapGesture {
            showingSheet.toggle()
        }
        .sheet(isPresented: $showingSheet) {
            ShiftDetailsView(item: shift)
        }
    }

    private var title: some View {
        Text(shift.localizedSpecialty.name)
            .font(.title2)
            .frame(idealWidth: .infinity, maxWidth: .infinity, alignment: .leading)
    }

    private var time: some View {
        return Text("From " + formatter.string(from: shift.startTime) + " to " + formatter.string(from: shift.endTime))
            .font(.caption)
            .frame(idealWidth: .infinity, maxWidth: .infinity, alignment: .leading)
    }

    private func badge(for type: ShiftDTO.ShiftFacilityDetails) -> some View {
        Text(type.name.prefix(1))
            .font(.caption)
            .fontWeight(.black)
            .padding(5)
            .background(Color(UIColor(hex: type.color) ?? .black))
            .clipShape(Circle())
            .foregroundColor(.white)
    }

    private var spinner: some View {
        Spinner(isAnimating: true, style: .medium)
    }
}
