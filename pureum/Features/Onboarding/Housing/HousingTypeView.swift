//
//  HousingTypeView.swift
//  pureum
//

import SwiftUI

struct HousingTypeView: View {
    
    private let headerGreen = Color(red: 36/255, green: 178/255, blue: 40/255)
    
    // 주거 형태 목록 (필요하면 수정)
    private let housingTypes = [
        "원룸 / 오피스텔",
        "기숙사",
        "쉐어하우스",
        "공공임대",
        "아파트",
        "기타"
    ]
    
    // 2열 그리드
    private let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]
    
    var body: some View {
        ZStack {
            GreenHeaderBackground()
            
            VStack {
                Spacer().frame(height: 100)
                
                Text("현재 어떤 집에 살고 있나요?")
                    .font(.title3)
                    .bold()
                    .padding(.horizontal, 24)
                    .frame(alignment: .leading)
                
                Text("가장 가까운 주거 형태를 선택해 주세요.")
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 24)
                
                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(housingTypes, id: \.self) { type in
                        NavigationLink(
                            destination: HousingCostView(housingType: type)
                        ) {
                            Text(type)
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
            .offset(y: 230)
        }
    }
}

#Preview {
    NavigationStack {
        HousingTypeView()
    }
}
