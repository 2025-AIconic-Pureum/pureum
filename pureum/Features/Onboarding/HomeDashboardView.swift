//
//  HomeDashboardView.swift
//  pureum
//

import SwiftUI

struct HomeDashboardView: View {
    
    private let headerGreen = Color(red: 36/255, green: 178/255, blue: 40/255)
    
    // TODO: 나중에 AppState나 서버에서 가져오도록 바꾸기
    var jobStatusText: String = "IT개발·데이터 / 정규직"
    var jobRegionText: String = "서울 서대문구"
    
    var housingStatusText: String = "원룸 / 월세"
    var housingRegionText: String = "서울 은평구"
    var housingCostText: String = "월 고정 주거비 약 45만 원"
    
    // 추천 더미 데이터
    let recommendedJobs: [String] = [
        "청년 IT 인턴십 (서대문구)",
        "주 20시간 개발 아르바이트",
        "디지털 역량 강화 교육 연계 일자리"
    ]
    
    let recommendedHousings: [String] = [
        "청년 전세임대 (LH)",
        "역세권 청년주택",
        "자립준비청년 우선 공급 원룸"
    ]
    
    let recommendedProjects: [String] = [
        "자립준비청년 취업 멘토링",
        "금융·저축 교육 프로그램",
        "심리·정서 지원 상담 프로그램"
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        
                        // MARK: - 상단 요약 카드 (일자리 / 주거)
                        Text("나의 현재 상태")
                            .font(.headline)
                            .padding(.horizontal, 20)
                            .padding(.top, 16)
                        
                        HStack(spacing: 16) {
                            // 일자리 카드
                            VStack(alignment: .leading, spacing: 8) {
                                Text("일자리")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                
                                Text(jobStatusText)
                                    .font(.headline)
                                
                                Text(jobRegionText)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.white)
                            .cornerRadius(16)
                            .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                            
                            // 주거 카드
                            VStack(alignment: .leading, spacing: 8) {
                                Text("주거")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                
                                Text(housingStatusText)
                                    .font(.headline)
                                
                                Text(housingRegionText)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                
                                Text(housingCostText)
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.white)
                            .cornerRadius(16)
                            .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                        }
                        .padding(.horizontal, 20)
                        
                        // MARK: - 추천 일자리
                        VStack(alignment: .leading, spacing: 12) {
                            Text("추천 일자리")
                                .font(.headline)
                            
                            ForEach(recommendedJobs, id: \.self) { job in
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(job)
                                            .font(.subheadline)
                                        Text("자립준비청년 우대 조건 포함")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.secondary)
                                }
                                .padding()
                                .background(Color.white)
                                .cornerRadius(12)
                                .shadow(color: Color.black.opacity(0.03), radius: 2, x: 0, y: 1)
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        // MARK: - 추천 주거
                        VStack(alignment: .leading, spacing: 12) {
                            Text("추천 주거")
                                .font(.headline)
                            
                            ForEach(recommendedHousings, id: \.self) { house in
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(house)
                                            .font(.subheadline)
                                        Text("현재 소득·주거비 기준으로 조회")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.secondary)
                                }
                                .padding()
                                .background(Color.white)
                                .cornerRadius(12)
                                .shadow(color: Color.black.opacity(0.03), radius: 2, x: 0, y: 1)
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        // MARK: - 추천 자립사업
                        VStack(alignment: .leading, spacing: 12) {
                            Text("추천 자립사업")
                                .font(.headline)
                            
                            ForEach(recommendedProjects, id: \.self) { project in
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(project)
                                            .font(.subheadline)
                                        Text("자립준비청년 대상 지원 프로그램")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.secondary)
                                }
                                .padding()
                                .background(Color.white)
                                .cornerRadius(12)
                                .shadow(color: Color.black.opacity(0.03), radius: 2, x: 0, y: 1)
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        Spacer(minLength: 40)
                    }
                }
            }
            .navigationTitle("푸름")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    HomeDashboardView()
}
