//
//  AnalyzingView.swift
//  pureum
//
//  Created by 김수진 on 11/18/25.
//
import SwiftUI

struct AnalyzingView: View {

    @EnvironmentObject var appState: AppState

    var body: some View {
        ZStack {
            Color.green.ignoresSafeArea()

            VStack(spacing: 16) {
                Spacer()

                Text("알려주신 내용을 토대로\n분석중이에요.")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)

                Spacer()

                Button {
                    appState.finishedOnboarding = true
                } label: {
                    Text("완료")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white)
                        .foregroundColor(.green)
                        .cornerRadius(12)
                        .padding(.horizontal, 24)
                        .padding(.bottom, 40)
                }
            }
        }
    }
}
