//
//  CategoryModel.swift
//  expenses-tracker
//
//  Created by Hassan Abdalla on 08/01/1448 AH.
//
import SwiftUI

enum CategoryModel: String, CaseIterable {
    case income = "Income"
    case expenses = "Expense"

    var image: String {

        switch self {
        case .income:
            return "arrow.up"
        case .expenses:
            return "arrow.down"
        }

    }

    var tintColor: Color {
        switch self {
        case .income:
            return .green
        case .expenses:
            return .red
        }
    }
}
