//
//  IntroScreen.swift
//  expenses-tracker
//
//  Created by Hassan Abdalla on 07/01/1448 AH.
//

import SwiftUI

struct IntroScreen: View {

    @AppStorage("isFirstTime") private var isFirstTime = true

    var body: some View {
        VStack {
            Text("What's new in the \nExpenses Tracker")
                .font(.largeTitle.bold())
                .multilineTextAlignment(.center)
                .padding(.top, 65)
                .padding(.bottom, 35)

            VStack(alignment: .leading, spacing: 35) {

                PointView(
                    symbol: "dollarsign",
                    title: "Transactions",
                    subtitle: "Keep track of your earning and expenses"
                )
                PointView(
                    symbol: "chart.bar.fill",
                    title: "Visual Charts",
                    subtitle:
                        "View your transactions using eye-catching graphics representation"
                )

                PointView(
                    symbol: "magnifyingglass",
                    title: "Advanced Filers",
                    subtitle:
                        "Find the expense you want by advanced search and filtering"
                )

            }
            .padding(.horizontal, 25)

            Spacer(minLength: 10)

            Button {
                isFirstTime.toggle()
                print("Current sheet is \(isFirstTime)")
            } label: {
                Text("Continue")
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .padding(.vertical, 14)
                    .frame(maxWidth: .infinity)
                    .background(
                        Constants.appTint.gradient,
                        in: .rect(cornerRadius: 12)
                    )
                    .contentShape(.rect)

            }

        }.padding(15)
    }

    //Points view
    @ViewBuilder
    func PointView(symbol: String, title: String, subtitle: String)
        -> some View
    {
        HStack(spacing: 20) {

            Image(systemName: symbol)
                .font(.largeTitle)
                .foregroundStyle(Constants.appTint.gradient)
                .frame(width: 45)

            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.title3)
                    .fontWeight(.semibold)

                Text(subtitle)
                    .foregroundColor(.gray)
            }

        }

    }

}

#Preview {
    IntroScreen()
}
