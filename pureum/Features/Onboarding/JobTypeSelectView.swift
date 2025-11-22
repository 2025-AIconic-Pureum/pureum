//
//  JobTypeSelectView.swift
//  pureum
//
//  Created by 김수진 on 11/22/25.
//

import SwiftUI

struct JobTypeSelectView: View {
    // 직종 카테고리 (앞 화면에서 넘어옴)
    let category: String

    // 고용 형태
    private let jobTypes = [
        "정규직", "알바", "프리랜서",
        "계약직", "인턴", "기타"
    ]
    
    // 초록 색상
    private let headerGreen = Color(red: 36/255, green: 178/255, blue: 40/255)
    
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
                
                Text("어떤 일자리인가요?")
                    .font(.title3)
                    .bold()
                    .padding(.horizontal, 24)
                    .frame(alignment: .leading)
                
                Text("\(category) 직종에서의 고용 형태를 선택해주세요.")
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 24)
                
                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(jobTypes, id: \.self) { type in
                        NavigationLink( destination: IncomeView(job: "\(category) / \(type)")
                        ) {
                            Text(type)
                                .font(.headline)
                                .frame(maxWidth: 200, minHeight: 60)
                                .background(Color.white)
                                .foregroundColor(.black)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.gray.opacity(0.3),
                                                lineWidth: 1)
                                )
                                .cornerRadius(12)
                        }
                    }
                }
                .padding(.horizontal, 150)
                
                Spacer()
            }
            .offset(y: 300)
        }
    }
}

#Preview {
    JobTypeSelectView(category: "IT개발·데이터")
}
