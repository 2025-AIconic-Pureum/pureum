//
//  AppState.swift
//  pureum
//

import Foundation
import SwiftUI

struct AuthResponseDTO: Codable {
    let userId: Int
    let hasOnboarded: Bool
    let accessToken: String
}

// MARK: - 내부 모델

struct AssetProfile {
    var currentAsset: Int
}

struct JobProfile {
    var category: String
    var jobType: String
    var regionSido: String
    var regionSigungu: String
    var monthlyIncome: Int
}

struct HousingProfile {
    var regionSido: String
    var regionSigungu: String
    var housingType: String
    var deposit: Int
    var monthlyCost: Int
}

// MARK: - DTOs (서버 1:1)

struct AssetDTO: Codable {
    let currentAsset: Int
}

struct JobDTO: Codable {
    let hasJob: Bool
    let category: String?
    let jobType: String?
    let region: String?
    let monthlyIncome: Int?
}

struct HousingDTO: Codable {
    let hasHousing: Bool
    let region: String?
    let housingType: String?
    let deposit: Int?
    let monthlyCost: Int?
}

struct OnboardingProfileRequestDTO: Codable {
    let userId: Int
    let asset: AssetDTO
    let job: JobDTO
    let housing: HousingDTO
}

struct UserProfileResponseDTO: Codable {
    let userId: Int
    let hasOnboarded: Bool
    let asset: Int

    let jobCategory: String?
    let jobType: String?
    let jobRegion: String?
    let monthlyIncome: Int?

    let housingRegion: String?
    let housingType: String?
    let deposit: Int?
    let monthlyCost: Int?
}

//분석

// MARK: - 집 후보 정보
struct HouseCandidate: Identifiable, Codable, Equatable {
    let id: UUID = UUID()
    let housingType: String   // 주거 형태 (원룸, 기숙사 등)
    let location: String      // 위치 (예: "대구 수성구")
    let deposit: Int          // 보증금
    let monthlyCost: Int      // 월 주거 비용
    enum CodingKeys: String, CodingKey {
        case housingType
        case location
        case deposit
        case monthlyCost
    }
}

// MARK: - 일자리 후보 정보
struct JobCandidate: Identifiable, Codable, Equatable {
    let id: UUID = UUID()
    let jobCategory: String
    let retype: String
    let location: String
    let salary: Int
    let career: String
    let education: String
    enum CodingKeys: String, CodingKey {
        case jobCategory
        case retype
        case location
        case salary
        case career
        case education 
    }
}

enum AnalysisMode {
    case houseJob   // 집 + 일자리 둘 다 추천
    case house      // 집만 추천 (일자리는 이미 있음)
    case job        // 일자리만 추천 (집은 이미 있음)
}

@MainActor
final class PlanRecommendationViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var resultText: String = ""   // 서버에서 받은 String 그대로 표시

    func runAnalysis(
        mode: AnalysisMode,
        houses: [HouseCandidate],
        jobs: [JobCandidate]
    ) async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            let result: String

            switch mode {
            case .houseJob:
                // 집 + 일자리 후보 같이 보내기
                result = try await AnalysisAPI.shared.recommendHouseJob(
                    houses: houses,
                    jobs: jobs
                )

            case .house:
                // 집만 보내기
                result = try await AnalysisAPI.shared.recommendHouseOnly(
                    houses: houses
                )

            case .job:
                // 일자리만 보내기
                result = try await AnalysisAPI.shared.recommendJobOnly(
                    jobs: jobs
                )
            }

            self.resultText = result

        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
}




// MARK: - AppState

final class AppState: ObservableObject {
    @Published var isLoggedIn: Bool = false
    @Published var hasOnboarded: Bool = false
    @Published var finishedOnboarding: Bool = false 

    @Published var assetProfile: AssetProfile?
    @Published var jobProfile: JobProfile?
    @Published var housingProfile: HousingProfile?

    @Published var userId: Int?
    @Published var accessToken: String?
    @Published var userName: String?


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


    // MARK: - 온보딩 요청 DTO 생성

    func makeOnboardingRequestDTO() -> OnboardingProfileRequestDTO? {
        guard let userId = userId else { return nil }

        print("📌 asset:", assetProfile as Any)
        print("📌 job:", jobProfile as Any)
        print("📌 housing:", housingProfile as Any)

        // ---- 자산 (필수) ----
        guard let asset = assetProfile else { return nil }
        let assetDTO = AssetDTO(currentAsset: asset.currentAsset)

        // ---- 일자리 (선택) ----
        let jobDTO: JobDTO = {
            if let job = jobProfile {
                return JobDTO(
                    hasJob: true,
                    category: job.category,
                    jobType: job.jobType,
                    region: "\(job.regionSido) \(job.regionSigungu)",
                    monthlyIncome: job.monthlyIncome
                )
            } else {
                return JobDTO(
                    hasJob: false,
                    category: nil,
                    jobType: nil,
                    region: nil,
                    monthlyIncome: nil
                )
            }
        }()

        // ---- 주거 (선택) ----
        let housingDTO: HousingDTO = {
            if let housing = housingProfile {
                return HousingDTO(
                    hasHousing: true,
                    region: "\(housing.regionSido) \(housing.regionSigungu)",
                    housingType: housing.housingType,
                    deposit: housing.deposit,
                    monthlyCost: housing.monthlyCost
                )
            } else {
                return HousingDTO(
                    hasHousing: false,
                    region: nil,
                    housingType: nil,
                    deposit: nil,
                    monthlyCost: nil
                )
            }
        }()

        return OnboardingProfileRequestDTO(
            userId: userId,
            asset: assetDTO,
            job: jobDTO,
            housing: housingDTO
        )
    }



    // MARK: - 서버 프로필 적용

    func applyUserProfile(_ res: UserProfileResponseDTO) {
        self.hasOnboarded = res.hasOnboarded

        // 자산
        self.assetProfile = AssetProfile(currentAsset: res.asset)

        // 일자리
        if let category = res.jobCategory,
           !category.isEmpty,
           let region = res.jobRegion {

            let parts = region.split(separator: " ").map { String($0) }
            let sido = parts.first ?? ""
            let sigungu = parts.count > 1 ? parts[1] : ""

            self.jobProfile = JobProfile(
                category: category,
                jobType: res.jobType ?? "",
                regionSido: sido,
                regionSigungu: sigungu,
                monthlyIncome: res.monthlyIncome ?? 0
            )
        } else {
            self.jobProfile = nil
        }

        // 주거
        if let region = res.housingRegion,
           !region.isEmpty {

            let parts = region.split(separator: " ").map { String($0) }
            let sido = parts.first ?? ""
            let sigungu = parts.count > 1 ? parts[1] : ""

            self.housingProfile = HousingProfile(
                regionSido: sido,
                regionSigungu: sigungu,
                housingType: res.housingType ?? "",
                deposit: res.deposit ?? 0,
                monthlyCost: res.monthlyCost ?? 0
            )
        } else {
            self.housingProfile = nil
        }
    }
}
