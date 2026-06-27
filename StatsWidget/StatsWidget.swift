//
//  StatsWidget.swift
//  StatsWidget
//
//  Created by Hassan Abdalla on 12/01/1448 AH.
//

import SwiftUI
import WidgetKit
import SwiftData

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> WidgetEntry {
        WidgetEntry(date: Date())
    }

    func getSnapshot(
        in context: Context,
        completion: @escaping (WidgetEntry) -> Void
    ) {
        let entry = WidgetEntry(date: Date())
        completion(entry)
    }

    func getTimeline(
        in context: Context,
        completion: @escaping (Timeline<Entry>) -> Void
    ) {
        var entries: [WidgetEntry] = []

        entries.append(.init(date: Date()))

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }

}

struct WidgetEntry: TimelineEntry {
    let date: Date
}

struct StatsWidgetEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        FilterTransactionView(
            startDate: .now.startOfMonth,
            endDate: .now.endOfMonth
        ) { transactions in

            CardView(
                income: total(transactions, category: .income),
                expense: total(transactions, category: .expenses)
            )
        }
    }
}

struct StatsWidget: Widget {
    let kind: String = "StatsWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            StatsWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
                .modelContainer(for:TransactionModel.self)
        }
        .supportedFamilies([.systemMedium])
        .contentMarginsDisabled()
        .configurationDisplayName("Epenses Overview")
        .description("Expenses Overview for the month")
    }
}

#Preview(as: .systemSmall) {
    StatsWidget()

} timeline: {
    WidgetEntry(date: .now)
}
