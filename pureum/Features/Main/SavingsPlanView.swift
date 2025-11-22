//
//  SavingsPlanView.swift
//  pureum
//

import SwiftUI

struct SavingsPlanView: View {
    
    private let headerGreen = Color(red: 36/255, green: 178/255, blue: 40/255)
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()
                
                VStack(alignment: .leading, spacing: 24) {
                    Text("저축 플랜")
                        .font(.title2)
                        .bold()
                        .padding(.top, 24)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("목표 금액")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text("₩ 10,000,000")
                            .font(.title3)
                            .bold()
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.white)
                    .cornerRadius(16)
                    .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("예상 기간")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text("약 24개월")
                            .font(.title3)
                            .bold()
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.white)
                    .cornerRadius(16)
                    .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
            }
            .navigationTitle("저축 플랜")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    SavingsPlanView()
}
