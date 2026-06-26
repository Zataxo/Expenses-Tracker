//
//  FilterView.swift
//  expenses-tracker
//
//  Created by Hassan Abdalla on 08/01/1448 AH.
//

import Combine
import SwiftUI

struct FilterView: View {
    @State private var searchText: String = ""
    @State private var filterText: String = ""

    @State private var selectedCategory: CategoryModel? = nil

    let searchPublisher = PassthroughSubject<String, Never>()

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 12) {

                    FilterTransactionView(
                        category: selectedCategory,
                        searchText: filterText
                    ) { transactions in
                        ForEach(transactions) { transaction in
                            NavigationLink {
                                TransactionView(
                                    transactionModel: transaction
                                )
                            } label: {
                                TransactionCardView(
                                    transaction: transaction,
                                    showCategory: true
                                )
                            }
                            .buttonStyle(.plain)

                        }
                    }

                }
                .padding(15)
            }
            .overlay {
                ContentUnavailableView(
                    "Search Transactions.",
                    systemImage: "magnifyingglass"
                )
                .opacity(filterText.isEmpty ? 1 : 0)
            }
            .searchable(text: $searchText, placement: .navigationBarDrawer)
            .onChange(of: searchText) { olvaValue, newValue in
                if newValue.isEmpty {
                    self.filterText = ""
                }

                searchPublisher.send(newValue)
            }
            .onReceive(
                searchPublisher.debounce(
                    for: 0.5,
                    scheduler: DispatchQueue.main
                )
            ) { incomingValue in

                filterText = incomingValue
                print(incomingValue)

            }

            .background(.gray.opacity(0.15))
            .navigationTitle("Search")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    ToolbarContent()
                }
            }
        }

    }

    @ViewBuilder
    private func ToolbarContent() -> some View {

        Menu {

            Button {
                self.selectedCategory = nil

            } label: {
                Text("Both")

                if self.selectedCategory == nil {

                    Image(systemName: "checkmark.circle.fill")
                        .font(.title3)

                }
            }

            ForEach(CategoryModel.allCases, id: \.rawValue) { category in

                Button {
                    self.selectedCategory = category
                } label: {
                    Text(category.rawValue)

                    if self.selectedCategory == category {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.title3)
                    }
                }

            }

        } label: {
            Image(systemName: "slider.vertical.3")
        }

    }
}

#Preview {
    FilterView()
}
