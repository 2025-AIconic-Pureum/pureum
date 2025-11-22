//
//  IntroView.swift
//  pureum
//
//  Created by 김수진 on 11/18/25.
//
import SwiftUI

struct IntroView: View {
    private let headerGreen = Color(red: 36/255, green: 178/255, blue: 40/255)

    var body: some View {
        ZStack {
            GreenHeaderBackground()

            VStack {
                Spacer()

                VStack(alignment: .leading, spacing: 24) {
                    Text("푸름.")
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    Text("당신이 자립하는 그날까지,\n당신의 푸른 내일을 함께합니다.")
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .offset(x: 120, y: 100)
                .padding(.horizontal, 24 )

                NavigationLink {
                    JobCheckView()
                } label: {
                    Text("시작하기")
                        .fontWeight(.semibold)
                        .frame(maxWidth: 280)
                        .padding()
                        .background(headerGreen)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .padding(.horizontal, 24)
                        .padding(.top, 24)
                        
                }
                .offset(x: 0, y: 100)
                

                Spacer()
            }
        }
    }
}
#Preview {
    IntroView()
}
