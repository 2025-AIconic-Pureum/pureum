//
//  RegisterView.swift
//  pureum
//
//  Created by 김수진 on 11/22/25.
//

// RegisterView.swift

import SwiftUI

struct RegisterView: View {
    
    @EnvironmentObject var appState: AppState
    
    @State private var email: String = ""
    @State private var name: String = ""
    @State private var password: String = ""
    @State private var passwordConfirm: String = ""
    
    @State private var isLoading = false
    @State private var errorMessage: String?
    
    private let headerGreen = Color(red: 36/255, green: 178/255, blue: 40/255)
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Spacer().frame(height: 40)
                
                VStack(spacing: 8) {
                    Text("푸름 시작하기")
                        .font(.title2)
                        .bold()
                    
                    Text("간단한 정보만 입력하면 자립 플랜을 함께 만들 수 있어요.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
                
                VStack(spacing: 16) {
                    TextField("이메일", text: $email)
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                    
                    TextField("이름 또는 닉네임", text: $name)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                    
                    SecureField("비밀번호", text: $password)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                    
                    SecureField("비밀번호 확인", text: $passwordConfirm)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                }
                .padding(.horizontal, 24)
                
                if let error = errorMessage {
                    Text(error)
                        .font(.footnote)
                        .foregroundColor(.red)
                        .padding(.horizontal, 24)
                }
                
                Button {
                    Task {
                        await register()
                    }
                } label: {
                    if isLoading {
                        ProgressView()
                            .tint(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                    } else {
                        Text("회원가입")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                    }
                }
                .background(canSubmit ? headerGreen : Color.gray.opacity(0.5))
                .foregroundColor(.white)
                .cornerRadius(12)
                .padding(.horizontal, 24)
                .disabled(!canSubmit || isLoading)
                
                Spacer().frame(height: 40)
            }
        }
    }
    
    private var canSubmit: Bool {
        !email.isEmpty &&
        !name.isEmpty &&
        !password.isEmpty &&
        password == passwordConfirm
    }
    
    private func register() async {
        errorMessage = nil
        
        guard password == passwordConfirm else {
            errorMessage = "비밀번호가 서로 일치하지 않습니다."
            return
        }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            let res = try await AuthAPI.register(email: email,
                                                 password: password,
                                                 name: name)
            await MainActor.run {
                appState.applyAuthResponse(res)
                appState.userName = name
            }
        } catch {
            await MainActor.run {
                errorMessage = error.localizedDescription
            }
        }
    }
}

#Preview {
    RegisterView()
        .environmentObject(AppState())
}
