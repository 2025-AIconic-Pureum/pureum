//
//  AuthRootView.swift
//  pureum
//
//  Created by 김수진 on 11/22/25.
//

// AuthRootView.swift

import SwiftUI

struct AuthRootView: View {
    
    @State private var isLoginMode: Bool = true
    
    var body: some View {
        VStack(spacing: 0) {
            Picker("", selection: $isLoginMode) {
                Text("로그인").tag(true)
                Text("회원가입").tag(false)
            }
            .pickerStyle(.segmented)
            .padding(.horizontal, 24)
            .padding(.top, 24)
            
            if isLoginMode {
                LoginView()
            } else {
                RegisterView()
            }
        }
    }
}

#Preview {
    AuthRootView()
        .environmentObject(AppState())
}
