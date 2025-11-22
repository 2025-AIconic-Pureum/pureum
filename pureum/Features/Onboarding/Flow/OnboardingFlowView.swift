//
//  OnboardingFlowView.swift
//  pureum
//
//  Created by 김수진 on 11/18/25.
//

import SwiftUI

struct OnboardingFlowView: View {

    @EnvironmentObject var appState: AppState

    var body: some View {
        NavigationStack {
            IntroView()
        }
    }
}
