//
//  pureumApp.swift
//  pureum
//
//  Created by 김수진 on 11/18/25.
//

import SwiftUI

@main
struct PooremApp: App {

    @StateObject private var appState = AppState()
    @StateObject var regionStore = RegionStore()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(appState)
                .environmentObject(regionStore)
        }
    }
}

struct RootView: View {

    @EnvironmentObject var appState: AppState

    var body: some View {
        Group {
            if !appState.isLoggedIn {
                AuthRootView()
            } else if !appState.hasOnboarded {
                OnboardingFlowView()
            } else {
                MainTabView()
            }
        }
    }
}

 
