//
//  FilterTransactionView.swift
//  expenses-tracker
//
//  Created by Hassan Abdalla on 11/01/1448 AH.
//

import SwiftData
import SwiftUI

struct FilterTransactionView<Content: View>: View {

    var content: ([TransactionModel]) -> Content
    @Query(animation: .snappy) private var transactions: [TransactionModel]

    init(
        category: CategoryModel?,
        searchText: String,
        @ViewBuilder content: @escaping ([TransactionModel]) -> Content
    ) {

        let categoryRawValue = category?.rawValue ?? ""
        let predicates = #Predicate<TransactionModel> { txn in

            (txn.title.localizedStandardContains(searchText)
                || txn.remark.localizedStandardContains(searchText))
                && (categoryRawValue.isEmpty
                    ? true : txn.category == categoryRawValue)

        }

        _transactions = Query(
            filter: predicates,
            sort: [
                SortDescriptor(\TransactionModel.dateAdded, order: .reverse)
            ],
            animation: .snappy
        )

        self.content = content

    }

    init(
        startDate: Date,
        endDate: Date,
        @ViewBuilder content: @escaping ([TransactionModel]) -> Content
    ) {

        let predicates = #Predicate<TransactionModel> { txn in

            txn.dateAdded >= startDate && txn.dateAdded <= endDate

        }

        _transactions = Query(
            filter: predicates,
            sort: [
                SortDescriptor(\TransactionModel.dateAdded, order: .reverse)
            ],
            animation: .snappy
        )

        self.content = content

    }
    var body: some View {
        content(transactions)
    }
}

//#Preview {
//    FilterTransactionView()
//}
