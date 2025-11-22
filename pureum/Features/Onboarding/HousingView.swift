//
//  HousingView.swift
//  pureum
//
//  Created by 김수진 on 11/22/25.
//
import SwiftUI

struct HousingView: View {
    
    let category: String
    let jobType: String
    
    private let headerGreen = Color(red: 36/255, green: 178/255, blue: 40/255)
    
    private let housings = [
        "원룸 / 오피스텔",
        "기숙사",
        "아파트",
        "쉐어하우스",
        "기타"
    ]
    
    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]
    
    var body: some View {
        ZStack {
            GreenHeaderBackground()
            
            VStack {
                Spacer().frame(height: 100)
                
                Text("현재 어떤 곳에 살고 있나요?")
                    .font(.title3)
                    .bold()
                    .padding(.horizontal, 24)
                    .frame(alignment: .leading)
                
                Text("\(category) · \(jobType) 기준으로\n주거 상황을 같이 고려할게요.")
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 24)
                
                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(housings, id: \.self) { house in
                        // 일단 다음 화면은 나중에 붙일 수 있게 Text로만 두었어
                        Button {
                            print("선택된 주거 형태: \(house)")
                            // TODO: 여기서 IncomeView 등으로 네비게이션 이어주기
                        } label: {
                            Text(house)
                                .font(.subheadline)
                                .multilineTextAlignment(.center)
                                .frame(maxWidth: .infinity, minHeight: 60)
                                .padding(.horizontal, 4)
                                .background(Color.white)
                                .foregroundColor(.black)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                )
                                .cornerRadius(12)
                        }
                    }
                }
                .padding(.horizontal, 150)
                
                Spacer()
            }
            .offset(x: 0, y: 300)
        }
    }
}

#Preview {
    HousingView(category: "IT개발·데이터", jobType: "정규직")
}
