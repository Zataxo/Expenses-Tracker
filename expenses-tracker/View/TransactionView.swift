//
//  NewExpensesView.swift
//  expenses-tracker
//
//  Created by Hassan Abdalla on 10/01/1448 AH.
//

import SwiftData
import SwiftUI

struct TransactionView: View {

    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss

    var transactionModel: TransactionModel?

    @State private var title: String = ""
    @State private var remark: String = ""
    @State private var amount: Double = .zero
    @State private var dateAdded: Date = .now
    @State private var category: CategoryModel = .expenses

    @State private var tintColor: TintColorModel = tintColors.randomElement()!

    var body: some View {
        ScrollView(.vertical) {

            VStack(spacing: 15) {
                Text("Preview")
                    .font(.caption)
                    .foregroundStyle(.gray)
                    .hSpacing(.leading)

                TransactionCardView(
                    transaction: .init(
                        title: title.isEmpty ? "Title" : title,
                        remark: remark.isEmpty ? "Remark" : remark,
                        amount: amount,
                        dateAdded: dateAdded,
                        category: category,
                        tintColor: tintColor
                    )
                )

                CustomTextfield("Title", "Magic Keyboard", value: $title)
                CustomTextfield("Remarks", "Apple Product!", value: $remark)

                VStack(alignment: .leading, spacing: 10) {

                    Text("Amount & Category")
                        .font(.caption)
                        .foregroundStyle(.gray)
                        .hSpacing(.leading)

                    HStack(spacing: 15) {

                        HStack(spacing: 4) {

                            Text(currencurySymbol)
                                .font(.callout.bold())

                            TextField(
                                "0.0",
                                value: $amount,
                                formatter: numberFormatter
                            )
                            .keyboardType(.decimalPad)

                        }
                        .padding(.horizontal, 15)
                        .padding(.vertical, 12)
                        .background(.background, in: .rect(cornerRadius: 10))
                        .frame(maxWidth: 130)

                        CustomCheckbox()

                    }

                }

                VStack(alignment: .leading, spacing: 10) {

                    Text("Date")
                        .font(.caption)
                        .foregroundStyle(.gray)
                        .hSpacing(.leading)

                    DatePicker(
                        "Pick a date",
                        selection: $dateAdded,
                        displayedComponents: [.date]
                    )
                    .datePickerStyle(.graphical)
                    .padding(.horizontal, 15)
                    .padding(.vertical, 12)
                    .background(.background, in: .rect(cornerRadius: 10))
                }

            }
            .padding(15)

        }
        .navigationTitle("Add Transaction")
        .background(.gray.opacity(0.15))
        .toolbar {

            ToolbarItem(placement: .topBarTrailing) {
                Button("Save", action: saveTransaction)
            }
        }
        .onAppear {
            if let transactionModel {
                self.title = transactionModel.title
                self.remark = transactionModel.remark
                self.amount = transactionModel.amount
                self.dateAdded = transactionModel.dateAdded

                if let category = transactionModel.categoryItem {

                    self.category = category
                }

                if let tintColor = transactionModel.tint {

                    self.tintColor = tintColor

                }
            }
        }
    }

    func saveTransaction() {

        if transactionModel != nil {
            transactionModel?.title = title
            transactionModel?.remark = remark
            transactionModel?.amount = amount
            transactionModel?.dateAdded = dateAdded
            transactionModel?.category = category.rawValue

        } else {
            let transaction = TransactionModel(
                title: title,
                remark: remark,
                amount: amount,
                dateAdded: dateAdded,
                category: category,
                tintColor: tintColor
            )
            context.insert(transaction)

        }

        dismiss()

    }

    @ViewBuilder
    private func CustomTextfield(
        _ title: String,
        _ hint: String,
        value: Binding<String>
    )
        -> some View
    {
        VStack(alignment: .leading, spacing: 10) {

            Text(title)
                .font(.caption)
                .foregroundStyle(.gray)
                .hSpacing(.leading)

            TextField(hint, text: value)
                .padding(.horizontal, 15)
                .padding(.vertical, 12)
                .background(.background, in: .rect(cornerRadius: 10))
        }
    }

    @ViewBuilder
    private func CustomCheckbox() -> some View {
        HStack(spacing: 10) {

            ForEach(CategoryModel.allCases, id: \.self) { category in
                HStack(spacing: 5) {

                    ZStack {
                        Image(systemName: "circle")
                            .font(.title3)
                            .foregroundStyle(Constants.appTint.gradient)

                        if self.category == category {
                            Image(systemName: "circle.fill")
                                .font(.caption)
                                .foregroundStyle(Constants.appTint.gradient)

                        }
                    }

                    Text(category.rawValue)
                        .font(.caption)

                }
                .contentShape(.rect)
                .onTapGesture {
                    withAnimation(.snappy) {
                        self.category = category
                    }
                }
            }

        }
        .padding(.horizontal, 15)
        .padding(.vertical, 12)
        .hSpacing(.leading)
        .background(.background, in: .rect(cornerRadius: 10))
    }

    var numberFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        return formatter
    }
}

#Preview {
    NavigationStack {
        TransactionView()
    }
}
