//
//  MainTabView.swift
//  pureum
//
//  Created by 김수진 on 11/22/25.
//

import SwiftUI

struct MainTabView: View {
    
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
    }
}

#Preview {
    MainTabView()
}
