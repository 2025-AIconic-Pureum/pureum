//
//  PlanRecommendationView.swift
//  pureum
//

//
//  PlanRecommendationView.swift
//  pureum
//

import SwiftUI

struct PlanRecommendationView: View {

    let houseCandidates: [HouseCandidate]
    let jobCandidates: [JobCandidate]

    private let lightGreen  = Color(red: 230/255, green: 245/255, blue: 235/255)
    
    var body: some View {
        VStack(spacing: 32) {
            
            // MARK: - 상단 안내문
            VStack(spacing: 10) {
                Text("어떤 플랜을 보고 싶나요?")
                    .font(.title2.bold())
                    .multilineTextAlignment(.center)

                Text("아래 옵션 중 하나를 선택하여\nAI가 맞춤 플랜을 추천해드려요.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.top, 40)

            // MARK: - 버튼 3개 (카드형)
            VStack(spacing: 16) {

                navigationCard(
                    title: "일자리 + 주거 플랜",
                    subtitle: "일자리와 집을 함께 묶어 추천받기",
                    destination: PlanFilterInputView(
                        mode: .houseJob,
                        houseCandidates: houseCandidates,
                        jobCandidates: jobCandidates
                    )
                )

                navigationCard(
                    title: "주거 플랜만",
                    subtitle: "희망 주거를 기준으로 집만 추천받기",
                    destination: PlanFilterInputView(
                        mode: .house,
                        houseCandidates: houseCandidates,
                        jobCandidates: jobCandidates
                    )
                )

                navigationCard(
                    title: "일자리 플랜만",
                    subtitle: "희망 일자리를 기준으로 일자리만 추천받기",
                    destination: PlanFilterInputView(
                        mode: .job,
                        houseCandidates: houseCandidates,
                        jobCandidates: jobCandidates
                    )
                )
            }

            Spacer()
        }
        .padding(.horizontal, 24)
        .navigationTitle("플랜 추천")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - 카드 버튼 공통 컴포넌트
    private func navigationCard<Destination: View>(
        title: String,
        subtitle: String,
        destination: Destination
    ) -> some View {
        NavigationLink(destination: destination) {
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)

                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding()
            .frame(maxWidth: .infinity, minHeight: 90, alignment: .leading)
            .background(lightGreen)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.07), radius: 10, x: 0, y: 3)
        }
    }
}
