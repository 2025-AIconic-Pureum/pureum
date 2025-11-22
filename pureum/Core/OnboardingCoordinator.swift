//
//  OnboardingCoordinator.swift
//  pureum
//
//  Created by 김수진 on 11/22/25.
//
// OnboardingCoordinator.swift

import Foundation

struct OnboardingCoordinator {
    static func completeOnboarding(
        appState: AppState,
        completion: @escaping (Bool) -> Void
    ) {
        // 1) 토큰, DTO 준비
        guard
            let token = appState.accessToken,
            let dto = appState.makeOnboardingRequestDTO()
        else {
            completion(false)
            return
        }

        // 2) API 호출
        OnboardingAPI.submitOnboarding(dto: dto, token: token) { success in
            DispatchQueue.main.async {
                if success {
                    // 서버 저장 성공 → 온보딩 완료 상태로
                    appState.finishedOnboarding = true
                    appState.hasOnboarded = true
                }
                completion(success)
            }
        }
    }
}
