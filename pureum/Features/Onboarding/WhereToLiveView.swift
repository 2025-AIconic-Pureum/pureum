//
//  WhereToLiveView.swift
//  pureum
//
//  Created by 김수진 on 11/18/25.
//

import SwiftUI

struct WhereToLiveView: View {

    @State private var location: String = ""

    var body: some View {
        ZStack {
            GreenHeaderBackground()

            VStack {
                Spacer()

                VStack(alignment: .leading, spacing: 8) {
                    Text("거주지역을 알려주세요.")
                        .font(.title3)
                        .fontWeight(.semibold)

                    Text("구체적인 정보면 더 좋아요.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 24)

                TextField("대구광역시 북구", text: $location)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .padding(.horizontal, 24)
                    .padding(.top, 16)

                NavigationLink {
                    InterestingJobView()   // 다음 화면
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
