//
//  SettingsView.swift
//  LangSwitch
//

import SwiftUI

struct SettingsView: View {
    @AppStorage(AppPreferences.launchAtLoginKey) private var launchAtLogin = AppPreferences.defaultLaunchAtLogin
    @AppStorage(AppPreferences.showInMenuBarKey) private var showInMenuBar = AppPreferences.defaultShowInMenuBar
    @AppStorage(AppPreferences.showInDockKey) private var showInDock = AppPreferences.defaultShowInDock

    let appDelegate: AppDelegate

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Toggle("Запускать при старте системы", isOn: $launchAtLogin)
                .onChange(of: launchAtLogin) { enabled in
                    appDelegate.setLaunchAtLogin(enabled)
                }

            Toggle("Показать в строке меню", isOn: $showInMenuBar)
                .onChange(of: showInMenuBar) { visible in
                    appDelegate.setStatusBarVisible(visible)
                }

            Toggle("Показать в док", isOn: $showInDock)
                .onChange(of: showInDock) { visible in
                    appDelegate.setShowInDock(visible)
                }
        }
        .padding(20)
        .frame(width: 360, alignment: .leading)
    }
}

struct AppPreferences {
    static let launchAtLoginKey = "launchAtLogin"
    static let showInMenuBarKey = "showInMenuBar"
    static let showInDockKey = "showInDock"

    static let defaultLaunchAtLogin = true
    static let defaultShowInMenuBar = true
    static let defaultShowInDock = false

    static var launchAtLogin: Bool {
        UserDefaults.standard.object(forKey: launchAtLoginKey) as? Bool ?? defaultLaunchAtLogin
    }

    static var showInMenuBar: Bool {
        UserDefaults.standard.object(forKey: showInMenuBarKey) as? Bool ?? defaultShowInMenuBar
    }

    static var showInDock: Bool {
        UserDefaults.standard.object(forKey: showInDockKey) as? Bool ?? defaultShowInDock
    }
}
