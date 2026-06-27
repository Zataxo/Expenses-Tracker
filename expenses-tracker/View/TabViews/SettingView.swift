//
//  SettingView.swift
//  expenses-tracker
//
//  Created by Hassan Abdalla on 08/01/1448 AH.
//

import SwiftUI

struct SettingView: View {

    @AppStorage("userName") private var userName: String = ""
    @AppStorage("isAppLocakedEnabled") private var isAppLocakedEnabled: Bool =
        false
    @AppStorage("lockWhenAppGoesBackground") private
        var lockWhenAppGoesBackground: Bool =
            false
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false

    @State private var isOn: Bool = false
    var body: some View {
        NavigationStack {

            List {

                Section("User Name") {

                    TextField("Hassan Abdalla", text: $userName)

                }
                
                Section("Theme") {
                    Toggle("Dark Mode", isOn: $isDarkMode)
                        .toggleStyle(SwitchToggleStyle(tint: Constants.appTint))
                }

                Section("App Lock") {

                    Toggle("Enable App Lock", isOn: $isAppLocakedEnabled)
                        .toggleStyle(SwitchToggleStyle(tint: Constants.appTint))
                        .onChange(of: isAppLocakedEnabled) {
                            oldValue,
                            newValue in
                            if oldValue != newValue && !newValue {
                                lockWhenAppGoesBackground = false

                            }

                        }

                    if isAppLocakedEnabled {
                        Toggle(
                            "Lock when app goes in background",
                            isOn: $lockWhenAppGoesBackground
                        )
                        .toggleStyle(SwitchToggleStyle(tint: Constants.appTint))
                    }

                }
            }
            .navigationTitle(Text("Settings"))
        }

    }
}

#Preview {
    ContentView()
}
