//
//  SettingsView.swift
//  LangSwitch
//
//  Created for configurable login and Dock behavior.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage(AppPreferences.launchAtLoginKey) private var launchAtLogin = AppPreferences.defaultLaunchAtLogin
    @AppStorage(AppPreferences.showInDockKey) private var showInDock = AppPreferences.defaultShowInDock

    let appDelegate: AppDelegate

    var body: some View {
        Form {
            Toggle("Launch at login", isOn: $launchAtLogin)
                .onChange(of: launchAtLogin) { enabled in
                    appDelegate.setLaunchAtLogin(enabled)
                }

            Toggle("Show in Dock", isOn: $showInDock)
                .onChange(of: showInDock) { enabled in
                    appDelegate.setShowInDock(enabled)
                }
        }
        .padding(20)
        .frame(width: 320)
    }
}

struct AppPreferences {
    static let launchAtLoginKey = "launchAtLogin"
    static let showInDockKey = "showInDock"

    // Preserve the app's pre-settings behavior for existing and new installations.
    static let defaultLaunchAtLogin = true
    static let defaultShowInDock = false

    static var launchAtLogin: Bool {
        UserDefaults.standard.object(forKey: launchAtLoginKey) as? Bool ?? defaultLaunchAtLogin
    }

    static var showInDock: Bool {
        UserDefaults.standard.object(forKey: showInDockKey) as? Bool ?? defaultShowInDock
    }
}
