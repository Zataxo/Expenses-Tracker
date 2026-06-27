//
//  ListTransactionsPerMonthView.swift
//  expenses-tracker
//
//  Created by Hassan Abdalla on 12/01/1448 AH.
//

import SwiftUI

struct ListTransactionsPerMonthView: View {
    let month: Date
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 15) {

                Section {
                    FilterTransactionView(
                        startDate: month.startOfMonth,
                        endDate: month.endOfMonth,
                        category: .income
                    ) { transactions in

                        ForEach(transactions) { transaction in

                            NavigationLink {
                                TransactionView(transactionModel: transaction)

                            } label: {
                                TransactionCardView(transaction: transaction)

                            }
                            .buttonStyle(.plain)

                        }

                    }

                } header: {
                    Text("Income")
                        .font(.caption)
                        .foregroundStyle(.gray)
                        .hSpacing(.leading)

                }

                Section {
                    FilterTransactionView(
                        startDate: month.startOfMonth,
                        endDate: month.endOfMonth,
                        category: .expenses

                    ) { transactions in

                        ForEach(transactions) { transaction in

                            NavigationLink {
                                TransactionView(transactionModel: transaction)

                            } label: {
                                TransactionCardView(transaction: transaction)

                            }
                            .buttonStyle(.plain)
                        }

                    }

                } header: {
                    Text("Expenses")
                        .font(.caption)
                        .foregroundStyle(.gray)
                        .hSpacing(.leading)

                }

            }
            .padding(15)

        }
        .background(.gray.opacity(0.15))
        .navigationTitle(format(date: month, format: "MMM yy"))

    }
}

#Preview {
    ListTransactionsPerMonthView(

        month: Date()
    )
}
