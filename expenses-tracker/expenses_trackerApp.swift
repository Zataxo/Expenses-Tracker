//
//  expenses_trackerApp.swift
//  expenses-tracker
//
//  Created by Hassan Abdalla on 07/01/1448 AH.
//

import SwiftData
import SwiftUI
import WidgetKit

@main
struct expenses_trackerApp: App {
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(isDarkMode ? .dark : .light)
                .onAppear{
                    WidgetCenter.shared.reloadAllTimelines()
                }

        }
        .modelContainer(for: TransactionModel.self)
    }
}
