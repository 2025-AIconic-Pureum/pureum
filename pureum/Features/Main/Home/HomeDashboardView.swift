//
//  HomeDashboardView.swift
//  pureum
//
import SwiftUI

struct HomeDashboardView: View {
    
    @EnvironmentObject var appState: AppState   // ✅ AppState 주입
    
    private let headerGreen = Color(red: 36/255, green: 178/255, blue: 40/255)
    private let lightGreen  = Color(red: 230/255, green: 245/255, blue: 235/255)

    // ✅ AppState 기반으로 동적으로 계산
    private var jobStatusText: String {
        if let job = appState.jobProfile {
            return "\(job.regionSido) \(job.regionSigungu)에 \(job.category) (\(job.jobType)), 월 \(job.monthlyIncome)원"
        } else {
            return "등록된 일자리가 없습니다."
        }
    }
    
    private var housingStatusText: String {
        if let h = appState.housingProfile {
            return "\(h.regionSido) \(h.regionSigungu) • \(h.housingType) • 월 \(h.monthlyCost)원"
        } else {
            return "아직 주거가 설정되지 않았습니다."
        }
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
                            
                            HStack(spacing: 10) {
                                Image(systemName: "briefcase.fill")
                                    .foregroundColor(headerGreen)
                                    .font(.title3)
                                
                                Text(jobStatusText)          // ✅ 여기서 appState를 반영
                                    .font(.subheadline)
                                    .foregroundColor(.black)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                            
                            Divider()
                            
                            HStack(spacing: 10) {
                                Image(systemName: "house.fill")
                                    .foregroundColor(headerGreen)
                                    .font(.title3)
                                
                                Text(housingStatusText)      // ✅ 여기서도 반영
                                    .font(.subheadline)
                                    .foregroundColor(.black)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(lightGreen.opacity(0.35))
                        .cornerRadius(24)
                        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                        .padding(.horizontal, 20)
                        
                        
                        // MARK: - 지금 할 수 있는 선택
                        VStack(alignment: .leading, spacing: 12) {
                            Text("지금 할 수 있는 선택")
                                .font(.title3)
                                .fontWeight(.bold)
                                .padding(.horizontal, 20)
                            
                            NavigationLink(
                                destination: PlanRecommendationView(houseCandidates: [], jobCandidates: [])
                                    .navigationBarBackButtonHidden(true)
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
                                            .fixedSize(horizontal: false, vertical: true)
                                    }
                                    
                                    Spacer()
                                }
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(headerGreen.opacity(0.15))
                                .cornerRadius(20)
                            }
                            .buttonStyle(.plain)
                            .padding(.horizontal, 20)
                        }
                        
                        // MARK: - 추천 섹션 (아래에서 다시 손 볼 거야)
                        VStack(alignment: .leading, spacing: 16) {
                            Text("추천 일자리")
                                .font(.headline)
                                .padding(.horizontal, 20)
                            
                            ForEach(0..<3) { _ in
                                RecommendationCard(title: "청년 디지털 일자리",
                                                   subtitle: "자립준비청년 우대 지원자격 포함")
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 16) {
                            Text("추천 주거")
                                .font(.headline)
                                .padding(.horizontal, 20)
                            
                            ForEach(0..<3) { _ in
                                RecommendationCard(title: "역세권 청년주택",
                                                   subtitle: "현재 소득·주거비 기준 적합")
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 16) {
                            Text("추천 자립사업")
                                .font(.headline)
                                .padding(.horizontal, 20)
                            
                            ForEach(0..<3) { _ in
                                RecommendationCard(title: "자립준비청년 월세지원",
                                                   subtitle: "자립지원 가능성 높은 프로그램")
                            }
                        }
                        
                        Spacer(minLength: 50)
                    }
                }
            }
            .navigationTitle("")
            .navigationBarHidden(true)
        }
    }
}
// MARK: - 작은 추천 카드 컴포넌트
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
        .environmentObject(AppState())   // ✅ Preview 에도 주입
}
