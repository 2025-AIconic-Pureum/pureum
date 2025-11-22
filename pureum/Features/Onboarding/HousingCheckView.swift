//
//  HousingCheckView.swift
//  pureum
//
//  Created by 김수진 on 11/22/25.
//

import SwiftUI

struct HousingCheckView: View {
    
    private let headerGreen = Color(red: 36/255, green: 178/255, blue: 40/255)
    
    var body: some View {
        ZStack {
            GreenHeaderBackground()
            
            VStack {
                Spacer().frame(height: 100)
                
                Text("현재 거주 중인 집이 있으신가요?")
                    .font(.title3)
                    .bold()
                    .padding(.horizontal, 24)
                    .frame(alignment: .leading)
                
                Text("예: 원룸, 기숙사 등")
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 30)
                
                // ✅ 집이 있을 때
                NavigationLink(destination: HousingRegionView()) {
                    Text("있어요")
                        .font(.headline)
                        .frame(maxWidth: 280)
                        .padding()
                        .background(headerGreen)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 12)
                
                // ✅ 집이 없을 때
                NavigationLink(destination: Text("다음 단계 (없어요)")) {
                    Text("없어요")
                        .font(.headline)
                        .frame(maxWidth: 280)
                        .padding()
                        .background(Color(red: 240/255, green: 240/255, blue: 240/255))
                        .foregroundColor(.black)
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
    HousingCheckView()
}
