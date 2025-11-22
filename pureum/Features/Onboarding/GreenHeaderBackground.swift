//
//  GreenHeaderBackground.swift
//  pureum
//
//  Created by 김수진 on 11/18/25.
//

import SwiftUI

struct GreenHeaderBackground: View {
    
    // 메인 초록 색 (필요하면 바꿔도 됨)
    private let headerGreen = Color(red: 36/255, green: 178/255, blue: 40/255)
    
    var body: some View {
        ZStack {
            Color.white
            
            // MARK: - 상단 큰 초록 원
            VStack(spacing: 0) {
                Circle()
                    .fill(headerGreen)
                    .frame(width: 600, height: 600)
                    .offset(x: 100, y: -310)   // 오른쪽 위로 크게 나가게
                Spacer()
            }
            
            // MARK: - 연한 원호 + 작은 초록 점
            ZStack {
                // 얇은 원 (테두리만)
                Circle()
                    .stroke(headerGreen.opacity(0.25), lineWidth: 2)
                    .frame(width: 600, height: 600)
                    .offset(x: -180, y: -350)
                
                // 작은 포인트 원
                Circle()
                    .fill(headerGreen)
                    .frame(width: 14, height: 14)
                    .offset(x: -150, y: -52)
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    GreenHeaderBackground()
}
