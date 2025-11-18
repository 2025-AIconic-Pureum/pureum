//
//  IncomeView.swift
//  pureum
//
//  Created by 김수진 on 11/18/25.
//

import SwiftUI

struct IncomeView: View {

    @State private var income: String = ""

    var body: some View {
        ZStack {
            GreenHeaderBackground()

            VStack {
                Spacer()

                VStack(alignment: .leading, spacing: 8) {
                    Text("현재 월소득을 알려주세요.")
                        .font(.title3)
                        .fontWeight(.semibold)

                    Text("대략적인 금액이어도 좋아요.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 24)

                TextField("5,000,000원", text: $income)
                    .keyboardType(.numberPad)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .padding(.horizontal, 24)
                    .padding(.top, 16)

                NavigationLink {
                    HowMuchView()     // 다음 페이지로 이동!
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
