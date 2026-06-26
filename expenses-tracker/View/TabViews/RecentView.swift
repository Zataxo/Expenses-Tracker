//
//  RecentView.swift
//  expenses-tracker
//
//  Created by Hassan Abdalla on 08/01/1448 AH.
//

import SwiftData
import SwiftUI

struct RecentView: View {
    @AppStorage("userName") private var userName: String = ""

    @State private var startDate: Date = .now.startOfMonth
    @State private var endDate: Date = .now.endOfMonth

    @State private var showNewExpenseForm: Bool = false

    @State private var selectedCategory: CategoryModel = .expenses
    @Namespace private var animation

    @State private var showFilterView: Bool = false

    @Environment(\.modelContext) private var context

    var body: some View {
        GeometryReader { geo in
            let size = geo.size
            let safeArea = geo.safeAreaInsets

            NavigationStack {
                ScrollView(.vertical) {
                    LazyVStack(spacing: 10, pinnedViews: .sectionHeaders) {

                        Section {
                            Button {
                                showFilterView = true
                            } label: {
                                Text(
                                    "\(format(date: startDate)) to \(format(date: endDate))"
                                )
                                .font(.caption2)
                                .foregroundStyle(.gray)
                            }
                            .hSpacing(.leading)

                            FilterTransactionView(
                                startDate: startDate,
                                endDate: endDate
                            ) { transactions in
                                CardView(
                                    income: total(
                                        transactions,
                                        category: .income
                                    ),
                                    expense: total(
                                        transactions,
                                        category: .expenses
                                    )
                                )

                                CustomSegmentedControl()
                                    .padding(.bottom, 10)

                                Group {
                                    if transactions.isEmpty {
                                        ContentUnavailableView {
                                            Label(
                                                "No Transactions Yet",
                                                systemImage: "tray.on.tray"
                                            )
                                        } description: {
                                            Text(
                                                "Add your first transaction to start tracking your expenses."
                                            )
                                        } actions: {
                                            Button("Add Transaction") {
                                                self.showNewExpenseForm.toggle()
                                            }
                                            .buttonStyle(.borderedProminent)
                                            .controlSize(.regular)
                                        }
                                        .transition(
                                            .opacity.combined(
                                                with: .scale(scale: 0.95)
                                            )
                                        )

                                    } else {
                                        ForEach(
                                            transactions.filter({ item in
                                                item.category
                                                    == selectedCategory.rawValue
                                            })
                                        ) { txn in

                                            NavigationLink(
                                                destination: TransactionView(
                                                    transactionModel: txn
                                                )
                                            ) {
                                                SwipeableRow(
                                                    actionWidth: 80,
                                                    onAction: {
                                                        context.delete(txn)
                                                    },
                                                    content: {

                                                        TransactionCardView(
                                                            transaction: txn
                                                        )
                                                    },
                                                    actionView: {

                                                        ZStack {
                                                            Color.red
                                                            Image(
                                                                systemName:
                                                                    "trash.fill"
                                                            )
                                                            .foregroundColor(
                                                                .white
                                                            )
                                                        }
                                                        .cornerRadius(10)
                                                        .padding(.vertical, 10)
                                                        .padding(
                                                            .horizontal,
                                                            10
                                                        )

                                                    },

                                                )
                                                //                                            .onTapGesture {
                                                //                                                self.showNewExpenseForm.toggle()
                                                //                                            }
                                            }

                                        }

                                    }
                                }

                            }

                        } header: {
                            HeaderView(size, safeArea: safeArea)

                        }

                    }
                    .padding(15)
                }
                .background(.gray.opacity(0.15))
                .navigationTitle("Recents")
                .navigationDestination(isPresented: $showNewExpenseForm) {
                    TransactionView(transactionModel: nil)
                }
                .toolbar(.hidden, for: .automatic)
                .overlay {
                    if showFilterView {
                        DateFilterView(
                            start: startDate,
                            end: endDate,
                            onSubmit: { start, end in
                                self.startDate = start
                                self.endDate = end

                                self.showFilterView = false

                            },
                            onClose: {
                                self.showFilterView = false
                            }
                        )
                        .transition(.move(edge: .leading))

                    }

                }.animation(.snappy, value: showFilterView)

            }
        }
    }

    @ViewBuilder
    func HeaderView(_ size: CGSize, safeArea: EdgeInsets) -> some View {

        HStack {

            VStack(alignment: .leading, spacing: 5) {

                Text("Welcome!")
                    .font(.title.bold())

                if !userName.isEmpty {
                    Text(userName)
                        .font(.callout)
                        .foregroundStyle(.gray)
                        .padding(.horizontal, 5)
                }
            }
            .visualEffect { content, geoProxy in
                content.scaleEffect(
                    headerScale(size, proxy: geoProxy),
                    anchor: .topLeading
                )
            }

            Spacer(minLength: 0)

            NavigationLink {
                TransactionView()

            } label: {
                Image(systemName: "plus")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(width: 45, height: 45)
                    .background(Constants.appTint.gradient, in: .circle)
                    .contentShape(.circle)
                //                    .clipShape(Circle())
            }

        }

        .padding(.bottom, 5)
        .background {
            VStack(spacing: 0) {
                Rectangle()
                    .fill(.ultraThinMaterial)
                Divider()

            }.visualEffect { content, proxy in
                content.opacity(headerBGOpacity(proxy: proxy, safeArea))
            }
            .padding(.horizontal, -15)
            .padding(.top, -(safeArea.top + 15))

        }

    }

    @ViewBuilder
    func CustomSegmentedControl() -> some View {
        HStack(spacing: 0) {

            ForEach(CategoryModel.allCases, id: \.rawValue) { category in

                Text(category.rawValue)
                    .fontWeight(
                        category.rawValue == selectedCategory.rawValue
                            ? .semibold : .regular
                    )
                    .hSpacing()
                    .padding(.vertical, 10)
                    .background {
                        if category == selectedCategory {
                            Capsule()
                                .fill(.background)
                                .matchedGeometryEffect(
                                    id: "ACTIVETAB",
                                    in: animation
                                )
                        }
                    }
                    .padding([.vertical, .horizontal], 8)

                    .contentShape(.capsule)
                    .onTapGesture {
                        withAnimation(.snappy) {
                            self.selectedCategory = category
                        }
                    }

            }
        }
        .background(.gray.opacity(0.15), in: .capsule)
        .padding(.top, 10)
    }

    nonisolated func headerBGOpacity(
        proxy: GeometryProxy,
        _ safeArea: EdgeInsets
    ) -> CGFloat {
        let minY = proxy.frame(in: .scrollView).minY + safeArea.top
        return minY > 0 ? 0 : (-minY / 15)
    }

    nonisolated func headerScale(_ size: CGSize, proxy: GeometryProxy)
        -> CGFloat
    {
        let minY = proxy.frame(in: .scrollView).minY
        let screenHeight = size.height

        let progress = minY / screenHeight

        let scale = (min(max(progress, 0), 1)) * 0.4

        return 1 + scale

    }
}

#Preview {
    ContentView()
}
