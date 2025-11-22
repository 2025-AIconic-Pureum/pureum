//
//  ProfileView.swift
//  pureum
//

import SwiftUI

struct ProfileView: View {
    
    private let headerGreen = Color(red: 36/255, green: 178/255, blue: 40/255)
    
    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("내 정보")) {
                    NavigationLink(destination: Text("기본 정보 수정 화면")) {
                        Text("기본 정보 수정")
                    }
                    NavigationLink(destination: JobCheckView()) {
                        Text("일자리 정보 다시 설정")
                    }
                    NavigationLink(destination: HousingCheckView()) {
                        Text("주거 정보 다시 설정")
                    }
                }
                
                Section(header: Text("저축/자립 계획")) {
                    NavigationLink(destination: Text("저축 목표 다시 설정 화면")) {
                        Text("저축 플랜 수정")
                    }
                    NavigationLink(destination: Text("자립 목표/계획 정리")) {
                        Text("자립 목표 관리")
                    }
                }
                
                Section {
                    Button(role: .destructive) {
                        // TODO: 로그아웃 / 초기화 로직
                    } label: {
                        Text("로그아웃")
                    }
                }
            }
            .navigationTitle("프로필")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    ProfileView()
}
