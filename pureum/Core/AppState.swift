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


struct AssetInfoDTO: Codable {
    let currentAsset: Int
}

struct JobInfoDTO: Codable {
    let hasJob: Bool
    let category: String?
    let jobType: String?
    let jobRegion: String?   // "서울 서대문구" 같은 풀 문자열로 보냄
    let monthlyIncome: Int?
}

struct HousingInfoDTO: Codable {
    let hasHousing: Bool
    let housingRegion: String? // "대구 북구"
    let housingType: String?
    let deposit: Int?          // 보증금
    let fixedHousingCost: Int? // 월 고정 주거비
}

struct OnboardingProfileRequestDTO: Codable {
    let userId: Int
    let asset: AssetInfoDTO?
    let job: JobInfoDTO?
    let housing: HousingInfoDTO?
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

        let assetDTO: AssetInfoDTO? = {
            guard let asset = assetProfile else { return nil }
            return AssetInfoDTO(currentAsset: asset.currentAsset)
        }()

        let jobDTO: JobInfoDTO? = {
            guard let job = jobProfile else {
                return JobInfoDTO(
                    hasJob: false,
                    category: nil,
                    jobType: nil,
                    jobRegion: nil,
                    monthlyIncome: nil
                )
            }

            let region = "\(job.regionSido) \(job.regionSigungu)"

            return JobInfoDTO(
                hasJob: true,
                category: job.category,
                jobType: job.jobType,
                jobRegion: region,
                monthlyIncome: job.monthlyIncome
            )
        }()

        let housingDTO: HousingInfoDTO? = {
            guard let housing = housingProfile else {
                return HousingInfoDTO(
                    hasHousing: false,
                    housingRegion: nil,
                    housingType: nil,
                    deposit: nil,
                    fixedHousingCost: nil
                )
            }

            let region = "\(housing.regionSido) \(housing.regionSigungu)"

            return HousingInfoDTO(
                hasHousing: true,
                housingRegion: region,
                housingType: housing.housingType,
                deposit: housing.deposit,
                fixedHousingCost: housing.monthlyCost
            )
        }()

        return OnboardingProfileRequestDTO(
            userId: userId,
            asset: assetDTO,
            job: jobDTO,
            housing: housingDTO
        )
    }

}
