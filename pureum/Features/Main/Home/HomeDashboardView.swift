//
//  HomeDashboardView.swift
//  pureum
//

import SwiftUI

struct HomeDashboardView: View {
    
    @EnvironmentObject var appState: AppState
    
    private let headerGreen = Color(red: 36/255, green: 178/255, blue: 40/255)
    private let lightGreen  = Color(red: 230/255, green: 245/255, blue: 235/255)
    
    // 금액 포매팅
    private func formatWon(_ value: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return (formatter.string(from: NSNumber(value: value)) ?? "\(value)") + "원"
    }
    
    private var jobStatusText: String {
        guard let job = appState.jobProfile else {
            return "등록된 일자리가 없습니다."
        }
        
        return """
        지역: \(job.regionSido) \(job.regionSigungu)
        직종: \(job.category)
        고용 형태: \(job.jobType)
        월 소득: \(formatWon(job.monthlyIncome))
        """
    }
    
    private var housingStatusText: String {
        guard let h = appState.housingProfile else {
            return "아직 주거가 설정되지 않았습니다."
        }
        
        return """
        지역: \(h.regionSido) \(h.regionSigungu)
        주거 형태: \(h.housingType)
        보증금: \(formatWon(h.deposit))
        월 주거비: \(formatWon(h.monthlyCost))
        """
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 28) {
                        
                        // MARK: - 상단 타이틀
                        VStack(alignment: .leading, spacing: 4) {
                            Text("푸름,")
                                .font(.largeTitle)
                                .fontWeight(.heavy)
                                .foregroundColor(headerGreen)
                            
                            Text("나의 자립 플랜")
                                .font(.largeTitle)
                                .fontWeight(.heavy)
                                .foregroundColor(.black)
                        }
                        .padding(.top, 12)
                        .padding(.horizontal, 20)
                        
                        
                        // MARK: - 상태 요약 카드
                        VStack(alignment: .leading, spacing: 16) {
                            
                            // --- 일자리 상태 카드
                            HStack(spacing: 10) {
                                Image(systemName: "briefcase.fill")
                                    .foregroundColor(headerGreen)
                                    .font(.title3)
                                
                                Text(jobStatusText)
                                    .font(.subheadline)
                                    .foregroundColor(.black)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                            
                            Divider()
                            
                            // --- 주거 상태 카드
                            NavigationLink {
                                if let housing = appState.housingProfile {
                                    HousingDetailView(housing: housing)
                                }
                            } label: {
                                HStack(spacing: 10) {
                                    Image(systemName: "house.fill")
                                        .foregroundColor(headerGreen)
                                        .font(.title3)
                                    
                                    Text(housingStatusText)
                                        .font(.subheadline)
                                        .foregroundColor(.black)
                                        .fixedSize(horizontal: false, vertical: true)
                                }
                            }
                            .buttonStyle(.plain)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(lightGreen.opacity(0.35))
                        .cornerRadius(24)
                        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                        .padding(.horizontal, 20)
                        
                        
                        // MARK: - 최근 저장된 플랜
                        if let plan = appState.confirmedPlan {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("최근 저장된 플랜")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .padding(.horizontal, 20)
                                
                                NavigationLink {
                                    Text(plan.detail)
                                        .padding()
                                } label: {
                                    HStack(alignment: .top, spacing: 12) {
                                        
                                        Image(systemName: "checkmark.seal.fill")
                                            .foregroundColor(headerGreen)
                                            .font(.title3)
                                            .padding(.top, 4)
                                        
                                        VStack(alignment: .leading, spacing: 6) {
                                            
                                            Text(plan.subtitle)
                                                .font(.headline)
                                                .foregroundColor(.black)
                                            
                                            Text(plan.detail)
                                                .font(.subheadline)
                                                .foregroundColor(.secondary)
                                                .fixedSize(horizontal: false, vertical: true)
                                        }
                                        
                                        Spacer()
                                    }
                                    .padding()
                                    .background(headerGreen.opacity(0.15))
                                    .cornerRadius(20)
                                }
                                .buttonStyle(.plain)
                                .padding(.horizontal, 20)
                            }
                        }
                        
                        
                        // MARK: - 지금 할 수 있는 선택
                        VStack(alignment: .leading, spacing: 12) {
                            Text("지금 할 수 있는 선택")
                                .font(.title3)
                                .fontWeight(.bold)
                                .padding(.horizontal, 20)
                            
                            NavigationLink(
                                destination: PlanRecommendationView(
                                    houseCandidates: [],
                                    jobCandidates: []
                                ).navigationBarBackButtonHidden(true)
                            ) {
                                HStack(alignment: .top, spacing: 12) {
                                    
                                    Image(systemName: "sparkles")
                                        .font(.title3)
                                        .foregroundColor(headerGreen)
                                        .padding(.top, 4)
                                    
                                    VStack(alignment: .leading, spacing: 6) {
                                        Text("일자리·주거 플랜 만들기")
                                            .font(.headline)
                                            .foregroundColor(.black)
                                        
                                        Text("기본 정보만 입력하면 처음부터 함께 설계해드려요.")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    }
                                    
                                    Spacer()
                                }
                                .padding()
                                .background(headerGreen.opacity(0.15))
                                .cornerRadius(20)
                            }
                            .buttonStyle(.plain)
                            .padding(.horizontal, 20)
                        }
                        
                        
                        // MARK: - 추천 일자리 (서버 연동)
                        VStack(alignment: .leading, spacing: 16) {
                            Text("추천 일자리")
                                .font(.headline)
                                .padding(.horizontal, 20)
                            
                            if let job = appState.recommendedJob {
                                RecommendationCard(
                                    title: job.title,
                                    subtitle: "\(job.company) · \(job.location)"
                                )
                            } else {
                                Text("추천된 일자리가 아직 없어요.")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                    .padding(.horizontal, 20)
                            }
                        }
                        
                        
                        // MARK: - 추천 주거 (서버 연동)
                        VStack(alignment: .leading, spacing: 16) {
                            Text("추천 주거")
                                .font(.headline)
                                .padding(.horizontal, 20)
                            
                            if let house = appState.recommendedHouse {
                                RecommendationCard(
                                    title: house.name,
                                    subtitle: "\(house.locationDisplay) · \(house.rentFeeDisplay)"
                                )
                            } else {
                                Text("추천된 주거가 아직 없어요.")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                    .padding(.horizontal, 20)
                            }
                        }
                        
                        
                        // MARK: - 추천 자립사업 (예시 유지)
                        VStack(alignment: .leading, spacing: 16) {
                            Text("추천 자립사업")
                                .font(.headline)
                                .padding(.horizontal, 20)
                            
                            RecommendationCard(
                                title: "자립준비청년 월세지원",
                                subtitle: "지자체·서울시 우대 프로그램"
                            )
                        }
                        
                        
                        Spacer(minLength: 50)
                    }
                }
            }
            .navigationTitle("")
            .navigationBarHidden(true)
        }
        .task {
            await appState.loadLastPlan()   // 🔥 홈 화면 로드시 최신 플랜 자동 로드
        }
    }
}


// MARK: - 추천 카드 컴포넌트
struct RecommendationCard: View {
    
    var title: String
    var subtitle: String
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 2)
        .padding(.horizontal, 20)
    }
}


#Preview {
    HomeDashboardView()
        .environmentObject(AppState())
}
