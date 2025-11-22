//
//  AppState.swift
//  pureum
//
//  Created by 김수진 on 11/18/25.
//

import Foundation
import SwiftUI

struct AssetProfile {
    var currentAsset: Int        // 현재 자산
}

struct JobProfile {
    var category: String      // 예: "IT개발·데이터"
    var jobType: String       // 예: "정규직"
    var regionSido: String    // 예: "서울"
    var regionSigungu: String // 예: "서대문구"
    var monthlyIncome: Int    // 월 소득
}

struct HousingProfile {
    var regionSido: String    // 예: "대구"
    var regionSigungu: String // 예: "북구"
    var housingType: String   // 예: "원룸 / 오피스텔"
    var deposit: Int          // 보증금
    var monthlyCost: Int      // 월 고정 주거비
}


// MARK: - Onboarding DTOs (서버 OnboardingSubmitRequest 와 1:1 매핑)

struct AssetDTO: Codable {
    let currentAsset: Int
}

struct JobDTO: Codable {
    let category: String
    let jobType: String
    let regionSido: String
    let regionSigungu: String
    let monthlyIncome: Int
}

struct HousingDTO: Codable {
    let regionSido: String
    let regionSigungu: String
    let housingType: String
    let deposit: Int
    let monthlyCost: Int
}

struct OnboardingProfileRequestDTO: Codable {
    let userId: Int
    let asset: AssetDTO
    let job: JobDTO
    let housing: HousingDTO
}



final class AppState: ObservableObject {
    @Published var isLoggedIn: Bool = false
    @Published var finishedOnboarding: Bool = false
    
    @Published var assetProfile: AssetProfile?
    @Published var jobProfile: JobProfile?
    @Published var housingProfile: HousingProfile?
    
    @Published var hasOnboarded = false
    @Published var userId: Int?
    @Published var accessToken: String?
    @Published var userName: String?   // 필요하면 나중에 세팅
    
    func applyAuthResponse(_ res: AuthResponseDTO) {
        self.userId = res.userId
        self.hasOnboarded = res.hasOnboarded
        self.accessToken = res.accessToken
        self.isLoggedIn = true
    }
    
    func logout() {
        isLoggedIn = false
        hasOnboarded = false
        userId = nil
        accessToken = nil
        userName = nil
    }


    func makeOnboardingRequestDTO() -> OnboardingProfileRequestDTO? {
        guard let userId = userId else { return nil }

        let assetDTO = AssetDTO(
            currentAsset: assetProfile?.currentAsset ?? 0
        )

        let jobDTO = JobDTO(
            category: jobProfile?.category ?? "",
            jobType: jobProfile?.jobType ?? "",
            regionSido: jobProfile?.regionSido ?? "",
            regionSigungu: jobProfile?.regionSigungu ?? "",
            monthlyIncome: jobProfile?.monthlyIncome ?? 0
        )

        let housingDTO = HousingDTO(
            regionSido: housingProfile?.regionSido ?? "",
            regionSigungu: housingProfile?.regionSigungu ?? "",
            housingType: housingProfile?.housingType ?? "",
            deposit: housingProfile?.deposit ?? 0,
            monthlyCost: housingProfile?.monthlyCost ?? 0
        )

        return OnboardingProfileRequestDTO(
            userId: userId,
            asset: assetDTO,
            job: jobDTO,
            housing: housingDTO
        )
    }


}
