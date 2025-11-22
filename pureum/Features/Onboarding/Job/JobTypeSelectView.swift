//
//  JobTypeSelectView.swift
//  pureum
//
//  Created by 김수진 on 11/22/25.
//
import SwiftUI

struct JobTypeSelectView: View {

    let category: String
    @EnvironmentObject var appState: AppState     // ✅ 추가: AppState 접근

    private let jobTypes = [
        "정규직", "알바", "프리랜서",
        "계약직", "인턴", "기타"
    ]
    
    private let headerGreen = Color(red: 36/255, green: 178/255, blue: 40/255)
    
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
                        
                        NavigationLink(destination: IncomeView(job: "\(category) / \(type)")) {
                            Text(type)
                                .font(.headline)
                                .frame(maxWidth: 200, minHeight: 60)
                                .background(Color.white)
                                .foregroundColor(.black)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                )
                                .cornerRadius(12)
                        }
                        // 👇 버튼 탭과 동시에 jobType 저장
                        .simultaneousGesture(TapGesture().onEnded {
                            if var job = appState.jobProfile {
                                job.jobType = type
                                appState.jobProfile = job
                            } else {
                                appState.jobProfile = JobProfile(
                                    category: category,
                                    jobType: type,
                                    regionSido: "",
                                    regionSigungu: "",
                                    monthlyIncome: 0
                                )
                            }
                            print("📌 저장됨: jobType =", type)
                        })
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
    NavigationStack {
        JobTypeSelectView(category: "IT개발·데이터")
            .environmentObject(AppState())   // 프리뷰용
    }
}
