//
//  MainTabView.swift
//  pureum
//
//  Created by 김수진 on 11/22/25.
//
import SwiftUI

struct MainTabView: View {
    
    @EnvironmentObject var appState: AppState
    @State private var isLoadingProfile = false
    @State private var didFetchProfile = false
    
    var body: some View {
        TabView {
            HomeDashboardView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("홈")
                }
            
            SavingsPlanView()
                .tabItem {
                    Image(systemName: "target")
                    Text("저축 플랜")
                }
            
            ProfileView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("프로필")
                }
        }
        .onAppear {
            fetchProfileIfNeeded()
        }
    }
    
    private func fetchProfileIfNeeded() {
        guard !didFetchProfile else { return }
        guard let userId = appState.userId,
              let token = appState.accessToken else {
            return
        }
        
        isLoadingProfile = true
        
        UserAPI.fetchProfile(userId: userId, token: token) { result in
            DispatchQueue.main.async {
                self.isLoadingProfile = false
                self.didFetchProfile = true
                
                switch result {
                case .success(let dto):
                    print("✅ 프로필 불러오기 성공:", dto)
                    appState.applyUserProfile(dto)
                case .failure(let error):
                    print("❌ 프로필 불러오기 실패:", error)
                }
            }
        }
    }
}

#Preview {
    MainTabView()
        .environmentObject(AppState())
}
