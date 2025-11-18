//
//  AccountView.swift
//  pureum
//
//  Created by 김수진 on 11/18/25.
//
import SwiftUI

struct AccountView: View {

    @State private var asset: String = ""

    var body: some View {
        ZStack {
            GreenHeaderBackground()

            VStack {
                Spacer()

                VStack(alignment: .leading, spacing: 8) {
                    Text("현재 자산을 알려주세요.")
                        .font(.title3)
                        .fontWeight(.semibold)
                    Text("가능한 대략적인 액수면 좋아요.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 24)

                TextField("5,000,000원", text: $asset)
                    .keyboardType(.numberPad)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .padding(.horizontal, 24)
                    .padding(.top, 16)

                NavigationLink {
                    IncomeView()
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
