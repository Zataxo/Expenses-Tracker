//
//  ContentView.swift
//  expenses-tracker
//
//  Created by Hassan Abdalla on 07/01/1448 AH.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("isFirstTime") private var isFirstTime = true

    @State private var activeTab: TabModel = .recents

    var body: some View {
        TabView(selection: $activeTab) {
            RecentView()
                .tag(TabModel.recents)
                .tabItem {
                    TabModel.recents.tabContent
                }

            FilterView()
                .tag(TabModel.search)
                .tabItem {
                    TabModel.search.tabContent
                }
            GraphView()
                .tag(TabModel.charts)
                .tabItem {
                    TabModel.charts.tabContent
                }
            SettingView()
                .tag(TabModel.settings)
                .tabItem {
                    TabModel.settings.tabContent
                }
        }.tint(Constants.appTint)

            .sheet(isPresented: $isFirstTime) {

                IntroScreen()
                    .interactiveDismissDisabled()
            }
    }
}

#Preview {
    ContentView()
}
