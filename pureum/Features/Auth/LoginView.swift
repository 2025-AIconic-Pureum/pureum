// LoginView.swift

import SwiftUI

struct LoginView: View {
    
    @EnvironmentObject var appState: AppState
    
    @State private var email: String = ""
    @State private var password: String = ""
    
    @State private var isLoading = false
    @State private var errorMessage: String?
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            VStack(spacing: 8) {
                Text("다시 만나서 반가워요!")
                    .font(.title2)
                    .bold()
                
                Text("로그인하고 나의 자립 플랜을 이어가요.")
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
                
                SecureField("비밀번호", text: $password)
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
                    await login()
                }
            } label: {
                if isLoading {
                    ProgressView()
                        .tint(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                } else {
                    Text("로그인")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                }
            }
            .background(Color(red: 36/255, green: 178/255, blue: 40/255))
            .foregroundColor(.white)
            .cornerRadius(12)
            .padding(.horizontal, 24)
            .disabled(isLoading || email.isEmpty || password.isEmpty)
            
            Spacer()
        }
    }
    
    private func login() async {
        errorMessage = nil
        isLoading = true
        defer { isLoading = false }
        
        do {
            let res = try await AuthAPI.login(email: email, password: password)
            await MainActor.run {
                appState.applyAuthResponse(res)
            }
        } catch {
            await MainActor.run {
                errorMessage = "로그인에 실패했습니다.\n이메일 또는 비밀번호를 확인해주세요."
            }
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(AppState())
}


#Preview {
    LoginView()
}
