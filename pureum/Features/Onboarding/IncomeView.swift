//
//  IncomeView.swift
//  pureum
//

import SwiftUI

struct IncomeView: View {
    
    @State private var income: String = ""
    let job: String      // "없음" 또는 "IT개발·데이터 / 정규직" 같은 설명
    
    private let headerGreen = Color(red: 36/255, green: 178/255, blue: 40/255)
    
    var body: some View {
        ZStack {
            GreenHeaderBackground()
            
            VStack {
                Spacer().frame(height: 100)
                
                Text("월 소득을 알려주세요.")
                    .font(.title3)
                    .bold()
                    .padding(.horizontal, 24)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text(job == "없음"
                     ? "현재 받는 소득이 없다면 0원을 입력해 주세요."
                     : "\(job) 기준 월 소득을 입력해 주세요.")
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 24)
                
                TextField("예: 1,500,000", text: $income)
                    .keyboardType(.numberPad)
                    .padding()
                    .frame(maxWidth: 280)
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 20)
                
                // ✅ 월 소득 입력 후 → 주거 체크 화면
                NavigationLink(destination: HousingCheckView()) {
                    Text("다음")
                        .font(.headline)
                        .frame(maxWidth: 280)
                        .padding()
                        .background(headerGreen)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .padding(.horizontal, 24)
                
                Spacer()
            }
            .offset(y: 300)
        }
    }
}

#Preview {
    IncomeView(job: "IT개발·데이터 / 정규직")
}
