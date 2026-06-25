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

    let searchPublisher = PassthroughSubject<String, Never>()

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 12) {

                }
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
        }

    }
}

#Preview {
    FilterView()
}
