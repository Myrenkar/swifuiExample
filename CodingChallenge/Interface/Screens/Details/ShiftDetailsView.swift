import SwiftUI

struct ShiftDetailsView: View {
    @Environment(\.presentationMode) var presentationMode

    let item: ShiftsViewModel.ListItem

    var body: some View {
        VStack(alignment: .leading) {
            Text(item.shiftKind)
                .font(.title2)
            Text("Is covid: \(String(describing: item.covid))")
            Text("Type: \(item.shiftKind)")
            Text(item.localizedSpecialty.name)
                .foregroundColor(Color(UIColor(hex: item.localizedSpecialty.specialty.color) ?? .black))

            Button("Press to dismiss") {
                presentationMode.wrappedValue.dismiss()
            }
            .font(.caption)
            .padding()
        }
    }
}
