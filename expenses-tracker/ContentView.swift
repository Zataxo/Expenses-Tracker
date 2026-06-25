//
//  ContentView.swift
//  expenses-tracker
//
//  Created by Hassan Abdalla on 07/01/1448 AH.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("isFirstTime") private var isFirstTime = true
    @AppStorage("isAppLocakedEnabled") private var isAppLocakedEnabled: Bool =
        false
    @AppStorage("lockWhenAppGoesBackground") private
        var lockWhenAppGoesBackground: Bool =
            false

    @State private var activeTab: TabModel = .recents

    var body: some View {

        LockView(
            lockType: .both,
            lockPin: "1234",
            isEnabled: isAppLocakedEnabled,
            lockWhenAppGoesBackground: lockWhenAppGoesBackground
        ) {

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
}

#Preview {
    ContentView()
}
