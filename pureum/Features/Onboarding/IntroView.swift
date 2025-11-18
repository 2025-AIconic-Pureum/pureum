//
//  IntroView.swift
//  pureum
//
//  Created by 김수진 on 11/18/25.
//
import SwiftUI

struct IntroView: View {

    var body: some View {
        ZStack {
            GreenHeaderBackground()

            VStack {
                Spacer()

                VStack(alignment: .leading, spacing: 12) {
                    Text("푸름.")
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    Text("당신이 자립하는 그날까지,\n당신의 푸른 내일을 함께합니다.")
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 24)

                NavigationLink {
                    AccountView()
                } label: {
                    Text("시작하기")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .padding(.horizontal, 24)
                        .padding(.top, 24)
                }

                Spacer()
            }
        }
    }
}
