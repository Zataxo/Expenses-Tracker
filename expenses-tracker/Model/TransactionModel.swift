//
//  TransactionModel.swift
//  expenses-tracker
//
//  Created by Hassan Abdalla on 08/01/1448 AH.
//

import SwiftUI

struct TransactionModel: Identifiable {

    let id: UUID = .init()

    var title: String
    var remark: String
    var amount: Double
    var dateAdded: Date
    var category: String
    var tintColor: String

    init(
        title: String,
        remark: String,
        amount: Double,
        dateAdded: Date,
        category: CategoryModel,
        tintColor: TintColorModel
    ) {
        self.title = title
        self.remark = remark
        self.amount = amount
        self.dateAdded = dateAdded
        self.category = category.rawValue
        self.tintColor = tintColor.color
    }

    var color: Color {
        tintColors.first(where: { $0.color == tintColor })?.value
            ?? Constants.appTint
    }

}

// Samples
var sampleTransactions: [TransactionModel] = [

    // generate samples
    .init(
        title: "Magic Keyboard",
        remark: "Apple Product",
        amount: 129,
        dateAdded: .now,
        category: .expenses,
        tintColor: tintColors.randomElement()!
    ),

    .init(
        title: "Icloud",
        remark: "Apple Subscription",
        amount: 3.99,
        dateAdded: .now,
        category: .income,
        tintColor: tintColors.randomElement()!
    ),
    .init(
        title: "Payment",
        remark: "Payment Received",
        amount: 2499,
        dateAdded: .now,
        category: .income,
        tintColor: tintColors.randomElement()!
    ),
    .init(
        title: "Apple Music",
        remark: "Subscription",
        amount: 4.99,
        dateAdded: .now,
        category: .expenses,
        tintColor: tintColors.randomElement()!
    ),

    .init(
        title: "Pubg Mobile",
        remark: "Subscription",
        amount: 37.99,
        dateAdded: .now,
        category: .expenses,
        tintColor: tintColors.randomElement()!
    ),
    .init(
        title: "Macbook Pro",
        remark: "Payment",
        amount: 8700,
        dateAdded: .now,
        category: .expenses,
        tintColor: tintColors.randomElement()!
    ),

]
