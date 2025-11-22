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
        guard
            let token = appState.accessToken,
            let dto = appState.makeOnboardingRequestDTO()
        else {
            // 👉 여기서 실패하면 수진님이 만든
            //    "정보 넘기기 실패" 알럿이 뜰 가능성이 큼
            completion(false)
            return
        }

        OnboardingAPI.submitOnboarding(dto: dto, token: token) { success in
            DispatchQueue.main.async {
                if success {
                    appState.finishedOnboarding = true
                    appState.hasOnboarded = true
                }
                completion(success)
            }
        }
    }
}
