//
//  DateFilterView.swift
//  expenses-tracker
//
//  Created by Hassan Abdalla on 09/01/1448 AH.
//

import SwiftUI

struct DateFilterView: View {
    @State var start: Date
    @State var end: Date

    var onSubmit: (Date, Date) -> Void
    var onClose: () -> Void
    var body: some View {
        VStack(spacing: 15) {

            DatePicker("Start", selection: $start, displayedComponents: [.date])
            DatePicker("End", selection: $end, displayedComponents: [.date])

            HStack(spacing: 15) {

                Button("Cancel") {
                    onClose()
                }
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.roundedRectangle(radius: 5))
                .tint(.red)

                Button("Filter") {
                    onSubmit(start, end)
                }
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.roundedRectangle(radius: 5))
                .tint(Constants.appTint)

            }
            .padding(.top, 10)

        }
        .padding(15)
        .background(.bar, in: .rect(cornerRadius: 10))
        .padding(.horizontal, 30)
    }
}

#Preview {
    DateFilterView(
        start: .now,
        end: .now,
        onSubmit: { e, r in },
        onClose: {}

    )
}
