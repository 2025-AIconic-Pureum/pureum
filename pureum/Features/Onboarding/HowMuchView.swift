//
//  HowMuchView.swift
//  pureum
//
//  Created by 김수진 on 11/18/25.
//

import SwiftUI

struct HowMuchView: View {

    @State private var months: String = ""
    @State private var targetAmount: String = ""

    var body: some View {
        ZStack {
            GreenHeaderBackground()

            VStack {
                Spacer()

                VStack(alignment: .leading, spacing: 16) {
                    Text("언제까지 모으고 싶으신가요?")
                        .font(.title3)
                        .fontWeight(.semibold)

                    TextField("10개월", text: $months)
                        .keyboardType(.numberPad)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)

                    Text("얼마를 모으고 싶으신가요?")
                        .font(.title3)
                        .fontWeight(.semibold)

                    TextField("5,000,000원", text: $targetAmount)
                        .keyboardType(.numberPad)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                }
                .padding(.horizontal, 24)

                NavigationLink {
                    WhereToLiveView()    // 다음 화면
                } label: {
                    Text("다음")
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
