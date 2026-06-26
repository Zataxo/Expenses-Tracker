//
//  TransactionCardView.swift
//  expenses-tracker
//
//  Created by Hassan Abdalla on 08/01/1448 AH.
//

import SwiftUI

struct TransactionCardView: View {
    let transaction: TransactionModel
    var showCategory: Bool = false
    var body: some View {
        HStack(spacing: 12) {

            Text(transaction.title.prefix(1))
                .font(.title)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .frame(width: 55, height: 55)
                .background(transaction.color.gradient, in: .circle)

            VStack(alignment: .leading, spacing: 4) {
                Text(transaction.title)
                    .foregroundColor(.primary)

                Text(transaction.remark)
                    .font(.caption)
                    .foregroundColor(.secondary)

                Text(format(date: transaction.dateAdded))
                    .font(.caption2)
                    .foregroundColor(.gray)

                if self.showCategory {
                    Text(transaction.category)
                        .font(.caption2)
                        .padding(.horizontal, 5)
                        .padding(.vertical, 2)
                        .background(
                            transaction.categoryItem == .expenses
                                ? Color.red.gradient : Color.green.gradient,
                            in: .capsule
                        )
                }
            }
            .lineLimit(1)
            .hSpacing(.leading)

            Text(currencyString(transaction.amount, allowedDigits: 0))
                .fontWeight(.semibold)

        }
        .padding(.horizontal, 15)
        .padding(.vertical, 10)
        .background(.background, in: .rect(cornerRadius: 10))

    }
}

#Preview {
    ContentView()
}
