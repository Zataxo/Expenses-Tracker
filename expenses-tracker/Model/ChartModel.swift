//
//  ChartModel.swift
//  expenses-tracker
//
//  Created by Hassan Abdalla on 11/01/1448 AH.
//

import SwiftUI

struct ChartModel: Identifiable {
    let id: UUID = .init()
    var date: Date
    var categories: [ChartCategoryModel]
    var totalIncome: Double
    var totalExpense: Double
}

struct ChartCategoryModel: Identifiable {
    let id: UUID = .init()
    var totalValue: Double
    var category: CategoryModel
}
