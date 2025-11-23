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
    /// 집 / 일자리 후보들 (없으면 빈 배열로 넘겨도 됨)
    let houseCandidates: [HouseCandidate]
    let jobCandidates: [JobCandidate]

    private let accentColor = Color.blue

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {

            // MARK: - 상단 설명
            VStack(alignment: .leading, spacing: 4) {
                Text("어떤 플랜을 보고 싶나요?")
                    .font(.title2).bold()

                Text("아래 3가지 중 하나를 선택하면, 해당 조건으로 AI가 플랜을 추천해 줄게요.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            // MARK: - 모드 선택 버튼 3개
            VStack(spacing: 10) {

                // 1) 일자리 + 주거 플랜
                NavigationLink {
                    PlanFilterInputView(
                        mode: .houseJob,
                        houseCandidates: houseCandidates,
                        jobCandidates: jobCandidates
                    )
                } label: {
                    modeButtonLabel(
                        title: "일자리 + 주거 플랜",
                        subtitle: "일자리와 집을 함께 묶어서 추천받기"
                    )
                }

                // 2) 주거 플랜만
                NavigationLink {
                    PlanFilterInputView(
                        mode: .house,
                        houseCandidates: houseCandidates,
                        jobCandidates: jobCandidates
                    )
                } label: {
                    modeButtonLabel(
                        title: "주거 플랜만",
                        subtitle: "현재 또는 희망 일자리를 기준으로 집만 추천받기"
                    )
                }

                // 3) 일자리 플랜만
                NavigationLink {
                    PlanFilterInputView(
                        mode: .job,
                        houseCandidates: houseCandidates,
                        jobCandidates: jobCandidates
                    )
                } label: {
                    modeButtonLabel(
                        title: "일자리 플랜만",
                        subtitle: "현재 거주지를 기준으로 일자리만 추천받기"
                    )
                }
            }

            Spacer()
        }
        .padding()
        .navigationTitle("플랜 추천")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - 공통 버튼 뷰

    private func modeButtonLabel(title: String, subtitle: String) -> some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: "wand.and.stars")
                .font(.title3)
                .foregroundColor(accentColor)
                .padding(.top, 4)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)

                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(accentColor.opacity(0.08))
        .cornerRadius(14)
    }
}
