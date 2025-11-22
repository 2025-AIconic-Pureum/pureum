//
//  HousingCheckView.swift
//  pureum
//
//  Created by 김수진 on 11/22/25.
//

import SwiftUI

struct HousingCheckView: View {
    
    @EnvironmentObject var appState: AppState
    
    @State private var goToMain = false
    @State private var isSubmitting = false
    @State private var showError = false
    
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
                
                Text("예: 원룸, 기숙사 등")
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 30)
                
                
                // 👉 집이 있을 때 (기존 그대로)
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
                
                
                // 👉 숨겨진 NavigationLink (화면 이동 담당)
                NavigationLink(destination: MainTabView(),
                               isActive: $goToMain) {
                    EmptyView()
                }
                
                // 👉 집이 없어요 버튼 (서버 전송 + 이동)
                Button {
                    handleNoHousing()
                } label: {
                    Text("없어요")
                        .font(.headline)
                        .frame(maxWidth: 280)
                        .padding()
                        .background(Color(red: 240/255, green: 240/255, blue: 240/255))
                        .foregroundColor(.black)
                        .cornerRadius(12)
                }
                .disabled(isSubmitting)
                .padding(.horizontal, 24)
                
                Spacer()
            }
            .offset(y: 300)
        }
        .alert("저장에 실패했어요", isPresented: $showError) {
            Button("확인", role: .cancel) {}
        } message: {
            Text("네트워크 상태를 확인해주세요.")
        }
    }
    
    
    // MARK: - 온보딩 완료 처리
    private func handleNoHousing() {
        // Housing 정보 없다고 설정
        appState.housingProfile = nil
        
        isSubmitting = true
        
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
    HousingCheckView()
        .environmentObject(AppState())
}
