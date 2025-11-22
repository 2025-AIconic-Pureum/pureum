//
//  HousingCostView.swift
//  pureum
//

import SwiftUI

struct HousingCostView: View {
    
    let housingType: String
    
    @State private var isOwner: Bool = false        // 자가 여부
    @State private var deposit: String = ""         // 보증금
    @State private var monthlyCost: String = ""     // 월 고정 주거비 (월세+관리비+대출 등)
    
    private let headerGreen = Color(red: 36/255, green: 178/255, blue: 40/255)
    
    var body: some View {
        ZStack {
            GreenHeaderBackground()
            
            VStack {
                Spacer().frame(height: 100)
                
                Text("주거 비용을 알려주세요.")
                    .font(.title3)
                    .bold()
                    .padding(.horizontal, 24)
                    .frame(alignment: .leading)
                
                Text("\(housingType)에 거주 중일 때의\n보증금과 월 고정 주거비를 입력해 주세요.")
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 12)
            
                
                // 보증금 (자가인 경우 0원 또는 미입력 안내)
                TextField("보증금 (예: 5,000,000)", text: $deposit)
                    .keyboardType(.numberPad)
                    .padding()
                    .frame(maxWidth: 280)
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 12)
                
                // 월 고정 주거비
                TextField(
                    isOwner
                    ? "월 고정 주거비 (관리비/대출 상환 등 포함)"
                    : "월 고정 주거비 (월세+관리비 등, 예: 400,000)",
                    text: $monthlyCost
                )
                .keyboardType(.numberPad)
                .padding()
                .frame(maxWidth: 280)
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
                
                NavigationLink(destination: MainTabView()) {
                    Text("다음")
                        .font(.headline)
                        .frame(maxWidth: 280)
                        .padding()
                        .background(canGoNext ? headerGreen : Color.gray.opacity(0.3))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .disabled(!canGoNext)
                
                Spacer()
            }
            .offset(y: 300)
        }
    }
    
    private var canGoNext: Bool {
        // 최소한 월 고정 주거비는 입력되도록
        !monthlyCost.isEmpty
    }
}

#Preview {
    NavigationStack {
        HousingCostView(housingType: "원룸 / 오피스텔")
    }
}
