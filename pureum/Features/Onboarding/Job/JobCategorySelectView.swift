//
//  JobCategorySelectView.swift
//  pureum
//
//  Created by 김수진 on 11/22/25.
//

//
//  JobCategorySelectView.swift
//  pureum
//

import SwiftUI

struct JobCategorySelectView: View {
    
    @EnvironmentObject var appState: AppState
    
    private let headerGreen = Color(red: 36/255, green: 178/255, blue: 40/255)
    
    private let categories = [
        "기획·전략",
        "마케팅·홍보·조사",
        "회계·세무·재무",
        "인사·노무·HRD",
        "총무·법무·사무",
        "IT개발·데이터",
        "디자인",
        "영업·판매·무역",
        "고객상담·TM",
        "구매·자재·물류",
        "상품기획·MD",
        "운전·운송·배송",
        "서비스",
        "생산",
        "건설·건축",
        "의료",
        "연구·R&D",
        "교육",
        "미디어·문화·스포츠",
        "금융·보험",
        "공공·복지"
    ]
    
    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]
    
    var body: some View {
        ZStack(alignment: .top) {
            GreenHeaderBackground()
            
            ScrollView {   // ✅ 전체 화면 스크롤 가능
                VStack(spacing: 20) {
                    Spacer().frame(height: 100)
                    
                    Text("어떤 직종에 가까운가요?")
                        .font(.title3)
                        .bold()
                        .padding(.horizontal, 24)
                        .frame(alignment: .leading)
                    
                    Text("해당되는 직종을 선택해주세요.")
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 24)
                        .padding(.bottom, 24)
                        .frame(alignment: .leading)
                    
                    LazyVGrid(columns: columns, spacing: 12) {
                        ForEach(categories, id: \.self) { category in
                            NavigationLink(
                                destination: JobTypeSelectView(category: category)
                            ) {
                                Text(category)
                                    .font(.subheadline)
                                    .multilineTextAlignment(.center)
                                    .frame(height: 60)
                                    .frame(maxWidth: .infinity)
                                    .padding(.horizontal, 4)
                                    .background(Color.white)
                                    .foregroundColor(.black)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                    )
                                    .cornerRadius(12)
                            }
                            .simultaneousGesture(TapGesture().onEnded {
                                if var job = appState.jobProfile {
                                    job.category = category
                                    appState.jobProfile = job
                                } else {
                                    appState.jobProfile = JobProfile(
                                        category: category,
                                        jobType: "",
                                        regionSido: "",
                                        regionSigungu: "",
                                        monthlyIncome: 0
                                    )
                                }
                            })
                        }
                    }
                    .padding(.horizontal, 150)

                    Spacer().frame(height: 280)
                }
                .offset(y: 230)
            }
        }
        .edgesIgnoringSafeArea(.top)  // ⬅️ 초록 헤더가 자연스럽게 들어가게
    }
}

#Preview {
    NavigationStack {
        JobCategorySelectView()
            .environmentObject(AppState())
    }
}
