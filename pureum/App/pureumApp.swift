//
//  pureumApp.swift
//  pureum
//
//  Created by 김수진 on 11/18/25.
//
//test

import SwiftUI

@main
struct PooremApp: App {

    @StateObject private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(appState)
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

