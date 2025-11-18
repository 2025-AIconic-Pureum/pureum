//
//  LoginView.swift
//  pureum
//
//  Created by 김수진 on 11/18/25.
//

import SwiftUI

struct LoginView: View {

    @EnvironmentObject var appState: AppState

    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showError: Bool = false

    var body: some View {
        VStack(spacing: 32) {

            Spacer()

            VStack(alignment: .leading, spacing: 8) {
                Text("푸름에 오신 걸 환영해요.")
                    .font(.title)
                    .fontWeight(.bold)

                Text("로그인하고 나만의 자립 플랜을 만들어보세요.")
                    .foregroundColor(.secondary)
                    .font(.subheadline)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 24)

            VStack(spacing: 16) {
                TextField("이메일", text: $email)
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)

                SecureField("비밀번호", text: $password)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
            }
            .padding(.horizontal, 24)

            if showError {
                Text("이메일 또는 비밀번호를 확인해주세요.")
                    .foregroundColor(.red)
                    .font(.footnote)
            }

            Button {
                login()
            } label: {
                Text("로그인")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(email.isEmpty || password.isEmpty ? Color.gray : Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .padding(.horizontal, 24)
            .disabled(email.isEmpty || password.isEmpty)

            Spacer()
        }
    }

    private func login() {
        // 임시 로그인 로직
        // 지금은 그냥 아무 값이나 넣으면 로그인 성공시킴
        if !email.isEmpty && !password.isEmpty {
            appState.isLoggedIn = true
            showError = false
        } else {
            showError = true
        }
    }
}
