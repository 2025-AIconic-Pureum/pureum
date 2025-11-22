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
            ContentView()
                .environmentObject(regionStore)
        }
    }
}

struct RootView: View {

    @EnvironmentObject var appState: AppState

    var body: some View {
        Group {
            if !appState.isLoggedIn {
                LoginView()
            } else if !appState.finishedOnboarding {
                OnboardingFlowView()
            } else {
                // TODO: 메인 화면
                Text("메인 화면 자리")
            }
        }
    }
}

 
