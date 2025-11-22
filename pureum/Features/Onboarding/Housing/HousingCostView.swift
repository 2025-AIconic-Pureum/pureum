//
//  HousingCostView.swift
//  pureum
//

import SwiftUI

struct HousingCostView: View {
    
    let housingType: String
    
    @EnvironmentObject var appState: AppState
    
    @State private var isOwner: Bool = false        // 자가 여부
    @State private var deposit: String = ""         // 보증금
    @State private var monthlyCost: String = ""     // 월 고정 주거비 (월세+관리비+대출 등)
    
    @State private var goToMain = false
    @State private var isSubmitting = false
    @State private var showError = false
    
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
                
                // 보증금
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
                
                // 숨겨진 네비게이션 링크 (화면 이동 담당)
                NavigationLink(destination: MainTabView(),
                               isActive: $goToMain) {
                    EmptyView()
                }
                
                // 다음 버튼
                Button {
                    handleNext()
                } label: {
                    Text("다음")
                        .font(.headline)
                        .frame(maxWidth: 280)
                        .padding()
                        .background(canGoNext ? headerGreen : Color.gray.opacity(0.3))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .disabled(!canGoNext || isSubmitting)
                
                Spacer()
            }
            .offset(y: 300)
        }
        .alert("저장에 실패했어요", isPresented: $showError) {
            Button("확인", role: .cancel) {}
        } message: {
            Text("네트워크 상태를 확인하고 다시 시도해 주세요.")
        }
    }
    
    private var canGoNext: Bool {
        !monthlyCost.isEmpty
    }
    
    // MARK: - 다음 버튼 로직 (housingProfile 세팅 + 온보딩 완료)
    private func handleNext() {
        guard canGoNext, !isSubmitting else { return }
        isSubmitting = true
        
        // 문자열 → 숫자 변환 (콤마 제거)
        let depositInt = Int(deposit.filter { $0.isNumber }) ?? 0
        let monthlyInt = Int(monthlyCost.filter { $0.isNumber }) ?? 0
        
        // 기존 region 정보가 이미 AppState.housingProfile 에 있을 수 있으니 보존
        let regionSido = appState.housingProfile?.regionSido ?? ""
        let regionSigungu = appState.housingProfile?.regionSigungu ?? ""
        
        // housingProfile 업데이트
        appState.housingProfile = HousingProfile(
            regionSido: regionSido,
            regionSigungu: regionSigungu,
            housingType: housingType,
            deposit: depositInt,
            monthlyCost: monthlyInt
        )
        
        // 온보딩 완료 + 서버 전송
        OnboardingCoordinator.completeOnboarding(appState: appState) { success in
            isSubmitting = false
            if success {
                goToMain = true
            } else {
                showError = true
            }
        }
    }
}

#Preview {
    NavigationStack {
        HousingCostView(housingType: "원룸 / 오피스텔")
            .environmentObject(AppState())
    }
}

