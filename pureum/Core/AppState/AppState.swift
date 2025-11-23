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

//---------------------------------------------
// MARK: - 분석 후보 입력 모델
//---------------------------------------------

struct HouseCandidate: Identifiable, Codable, Equatable {
    let id: UUID = UUID()
    let housingType: String
    let location: String
    let deposit: Int
    let monthlyCost: Int
}

struct JobCandidate: Identifiable, Codable, Equatable {
    let id: UUID = UUID()
    let jobCategory: String
    let retype: String
    let location: String
    let salary: Int
    let career: String
    let education: String
}

enum AnalysisMode {
    case houseJob
    case house
    case job
}

//---------------------------------------------
// MARK: - 🔥 변경 핵심: 백엔드 최신 구조 반영
//---------------------------------------------

/// 백엔드: PlanRecommendationResponse
struct PlanRecommendationResponse: Codable {
    let combos: [PlanRecommendationItem]
}

struct PlanRecommendationItem: Codable, Identifiable {
    let rank: Int
    let house: PlanHouseInfo
    let job: PlanJobInfo
    let reason: String

    var id: Int { rank }
}

struct PlanHouseInfo: Codable {
    let id: String
    let locationDisplay: String
    let name: String
    let housingTypeDetail: String
    let depositDisplay: String
    let rentFeeDisplay: String
    let maintenanceFeeDisplay: String
    let surrounding: String
}

struct PlanJobInfo: Codable {
    let id: String
    let title: String
    let company: String
    let location: String
    let career: String
    let edu: String
    let salaryDisplay: String
    let workTimeDisplay: String
    let requirements: String
}

//---------------------------------------------
// MARK: - 기존 저장 요청 DTO (건드리지 않음)
//---------------------------------------------
/// 서버 /analysis/save 에 보낼 저장 요청 DTO
struct PlanSelectionRequestDTO: Codable {
    let userId: Int
    let rank: Int
    let houseId: String?
    let jobId: String?
    let reason: String
}

struct PlanSaveRequest: Codable {
    let userId: Int
    let mode: String
    let combos: [PlanRecommendationItem]
}


struct HousingJobCombo: Codable, Identifiable {
    let rank: Int
    let house: String
    let job: String
    let reason: String

    var id: Int { rank }
}

struct HousingJobPlanResponse: Codable {
    let combos: [HousingJobCombo]
}

struct HousingOnlyItem: Codable, Identifiable {
    let rank: Int
    let house: String
    let reason: String

    var id: Int { rank }
}

struct HousingOnlyPlanResponse: Codable {
    let houses: [HousingOnlyItem]
}

struct JobOnlyItem: Codable, Identifiable {
    let rank: Int
    let job: String
    let reason: String

    var id: Int { rank }
}

struct JobOnlyPlanResponse: Codable {
    let jobs: [JobOnlyItem]
}

struct PlanSelectionResponse: Codable {
    let id: Int?
    let userId: Int
    let rank: Int
    let houseId: String?
    let jobId: String?
    let reason: String
    let createdAt: String
}



//---------------------------------------------
// MARK: - ViewModel 수정
//---------------------------------------------

@MainActor
final class PlanRecommendationViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var errorMessage: String?

    // 🔥 이제 이걸 사용함
    @Published var fullResult: PlanRecommendationResponse?

    func runAnalysis(
        mode: AnalysisMode,
        houses: [HouseCandidate],
        jobs: [JobCandidate]
    ) async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            switch mode {
            case .houseJob:
                fullResult = try await AnalysisAPI.shared.recommendHouseJob(houses: houses, jobs: jobs)
            case .house:
                // 백엔드에서 house-only에도 동일 구조를 사용한다면 이것도 recommendFull로 구현
                fullResult = try await AnalysisAPI.shared.recommendHouseOnly(houses: houses)
            case .job:
                fullResult = try await AnalysisAPI.shared.recommendJobOnly(jobs: jobs)
            }

        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
}

//---------------------------------------------
// MARK: - AppState 이하 기존 그대로 유지
//---------------------------------------------

enum ConfirmedPlanMode: String, Codable {
    case houseJob
    case house
    case job
}

struct ConfirmedPlan: Identifiable, Codable {
    let id = UUID()
    let mode: ConfirmedPlanMode
    let title: String
    let subtitle: String
    let detail: String
}

struct LastPlanResponse: Codable {
    let id: Int
    let userId: Int
    let rank: Int
    let house: PlanHouseInfo?
    let job: PlanJobInfo?
    let reason: String
    let createdAt: String
}

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
    @Published var confirmedPlan: ConfirmedPlan?

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

        guard let asset = assetProfile else { return nil }
        let assetDTO = AssetDTO(currentAsset: asset.currentAsset)

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
                return JobDTO(hasJob: false, category: nil, jobType: nil, region: nil, monthlyIncome: nil)
            }
        }()

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
                return HousingDTO(hasHousing: false, region: nil, housingType: nil, deposit: nil, monthlyCost: nil)
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

        self.assetProfile = AssetProfile(currentAsset: res.asset)

        if let category = res.jobCategory,
           !category.isEmpty,
           let region = res.jobRegion {

            let parts = region.split(separator: " ").map { String($0) }

            self.jobProfile = JobProfile(
                category: category,
                jobType: res.jobType ?? "",
                regionSido: parts.first ?? "",
                regionSigungu: parts.count > 1 ? parts[1] : "",
                monthlyIncome: res.monthlyIncome ?? 0
            )
        } else {
            self.jobProfile = nil
        }

        if let region = res.housingRegion,
           !region.isEmpty {

            let parts = region.split(separator: " ").map { String($0) }

            self.housingProfile = HousingProfile(
                regionSido: parts.first ?? "",
                regionSigungu: parts.count > 1 ? parts[1] : "",
                housingType: res.housingType ?? "",
                deposit: res.deposit ?? 0,
                monthlyCost: res.monthlyCost ?? 0
            )
        } else {
            self.housingProfile = nil
        }
    }
    
    @Published var recommendedHouse: PlanHouseInfo?
    @Published var recommendedJob: PlanJobInfo?

    
    func loadLastPlan() async {
        guard let userId = userId else { return }
        
        do {
            let last = try await AnalysisAPI.shared.fetchLastPlan(userId: userId)

            await MainActor.run {
                self.confirmedPlan = ConfirmedPlan(
                    mode: .houseJob,
                    title: "최근 저장된 플랜",
                    subtitle: "⭐️ \(last.rank)위 추천",
                    detail: last.reason
                )

                // 🔥 FULL 상세가 이미 API에 있으므로 바로 세팅
                self.recommendedHouse = last.house
                self.recommendedJob = last.job
            }
        } catch {
            print("최근 플랜 로드 실패:", error)
        }
    }


}
