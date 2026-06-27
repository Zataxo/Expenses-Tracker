//
//  GraphView.swift
//  expenses-tracker
//
//  Created by Hassan Abdalla on 08/01/1448 AH.
//

import Charts
import SwiftData
import SwiftUI

struct GraphView: View {
    @State private var showNewExpenseForm: Bool = false
    @Query(animation: .snappy) private var transactions: [TransactionModel]
    
    // MARK: - Computed Property (Replaces @State & createChartData)
    var chartGroup: [ChartModel] {
        let calendar = Calendar.current
        
        // Group transactions by month/year components
        let groupedByDate = Dictionary(grouping: transactions) { txn in
            calendar.dateComponents([.month, .year], from: txn.dateAdded)
        }
        
        // Sort the grouped keys chronologically
        let sortedGroups = groupedByDate.sorted {
            let date1 = calendar.date(from: $0.key) ?? Date()
            let date2 = calendar.date(from: $1.key) ?? Date()
            return calendar.compare(date1, to: date2, toGranularity: .day) == .orderedAscending
        }
        
        return sortedGroups.compactMap { dict -> ChartModel? in
            let date = calendar.date(from: dict.key) ?? Date()
            
            let income = dict.value.filter { $0.category == CategoryModel.income.rawValue }
            let expense = dict.value.filter { $0.category == CategoryModel.expenses.rawValue }
            
            let incomeTotal = total(income, category: .income)
            let expenseTotal = total(expense, category: .expenses)
            
            return ChartModel(
                date: date,
                categories: [
                    .init(totalValue: incomeTotal, category: .income),
                    .init(totalValue: expenseTotal, category: .expenses)
                ],
                totalIncome: incomeTotal,
                totalExpense: expenseTotal
            )
        }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                Group {
                    if chartGroup.isEmpty {
                        ContentUnavailableView {
                            Label("No Transactions Yet", systemImage: "tray.on.tray")
                        } description: {
                            Text("Add your first transaction to start visualizing your expenses.")
                        } actions: {
                            Button("Add Transaction") {
                                showNewExpenseForm.toggle()
                            }
                            .buttonStyle(.borderedProminent)
                            .controlSize(.regular)
                        }
                        .transition(.opacity.combined(with: .scale(scale: 0.95)))
                    } else {
                        LazyVStack(spacing: 10) {
                            ChartView()
                                .frame(height: 200)
                                .padding(10)
                                .padding(.top, 10)
                                .background(.background, in: .rect(cornerRadius: 10))
                            
                            ForEach(chartGroup) { group in
                                VStack(alignment: .leading, spacing: 10) {
                                    Text(format(date: group.date, format: "MMM yy"))
                                        .font(.caption)
                                        .foregroundStyle(.gray)
                                        .hSpacing(.leading)
                                    
                                    NavigationLink {
                                        ListTransactionsPerMonthView(month: group.date)
                                    } label: {
                                        CardView(
                                            income: group.totalIncome,
                                            expense: group.totalExpense
                                        )
                                    }
                                }
                            }
                        }
                        .padding(15)
                    }
                }
            }
            .navigationDestination(isPresented: $showNewExpenseForm) {
                TransactionView(transactionModel: nil)
            }
            .scrollIndicators(.hidden)
            .navigationTitle("Graphs")
            .background(.gray.opacity(0.15))
        }
    }
    
    @ViewBuilder
    func ChartView() -> some View {
        Chart {
            ForEach(chartGroup) { group in
                ForEach(group.categories) { chart in
                    BarMark(
                        x: .value("Month", format(date: group.date, format: "MMM yy")),
                        y: .value(chart.category.rawValue, chart.totalValue),
                        width: 20
                    )
                    .position(by: .value("Category", chart.category.rawValue), axis: .horizontal)
                    .foregroundStyle(by: .value("Category", chart.category.rawValue))
                }
            }
        }
        .chartScrollableAxes(.horizontal)
        .chartXVisibleDomain(length: 4)
        .chartForegroundStyleScale(range: [Color.green.gradient, Color.red.gradient])
        .chartLegend(position: .bottom, alignment: .trailing)
        .chartYAxis {
            AxisMarks(position: .leading) { mark in
                let doubleValue = mark.as(Double.self) ?? 0
                AxisGridLine()
                AxisTick()
                AxisValueLabel {
                    Text("\(axisLabel(for: doubleValue))")
                }
            }
        }
    }
    
    func axisLabel(for value: Double) -> String {
        let intValue = Int(value)
        let kValue = Int(value) / 1000
        return intValue < 1000 ? "\(intValue)" : "\(kValue)K"
    }
}
#Preview {
    GraphView()
}
