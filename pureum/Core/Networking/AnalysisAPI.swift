//
//  AnalysisAPI.swift
//  pureum
//
//  Created by 김수진 on 11/22/25.
//
import Foundation

// MARK: - 요청 바디 DTO

struct HouseJobRequest: Codable {
    let houses: [HouseCandidate]
    let jobs: [JobCandidate]
}

struct HouseOnlyRequest: Codable {
    let houses: [HouseCandidate]
}

struct JobOnlyRequest: Codable {
    let jobs: [JobCandidate]
}

// MARK: - AnalysisAPI
// MARK: - AnalysisAPI
final class AnalysisAPI {
    static let shared = AnalysisAPI()
    private init() {}

    private let baseURL = URL(string: "http://192.168.219.104:8080")!

    private func post<Request: Encodable>(
        path: String,
        body: Request
    ) async throws -> Data {

        let url = baseURL.appendingPathComponent(path)
        var request = URLRequest(url: url)

        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(body)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              200..<300 ~= httpResponse.statusCode else {
            throw NSError(
                domain: "AnalysisAPI",
                code: (response as? HTTPURLResponse)?.statusCode ?? -1,
                userInfo: nil
            )
        }

        return data
    }

    // MARK: - 집 + 일자리 추천
    func recommendHouseJob(
        houses: [HouseCandidate],
        jobs: [JobCandidate]
    ) async throws -> PlanRecommendationResponse {
        let body = HouseJobRequest(houses: houses, jobs: jobs)
        let data = try await post(path: "/analysis/house_job", body: body)
        print("🔥 서버 응답:", String(data: data, encoding: .utf8) ?? "nil")
        return try JSONDecoder().decode(PlanRecommendationResponse.self, from: data)
    }

    // MARK: - 집만 추천
    func recommendHouseOnly(
        houses: [HouseCandidate]
    ) async throws -> PlanRecommendationResponse {
        let body = HouseOnlyRequest(houses: houses)
        let data = try await post(path: "/analysis/house", body: body)
        print("🔥 서버 응답:", String(data: data, encoding: .utf8) ?? "nil")
        return try JSONDecoder().decode(PlanRecommendationResponse.self, from: data)
    }

    // MARK: - 일자리만 추천
    func recommendJobOnly(
        jobs: [JobCandidate]
    ) async throws -> PlanRecommendationResponse {
        let body = JobOnlyRequest(jobs: jobs)
        let data = try await post(path: "/analysis/job", body: body)
        print("🔥 서버 응답:", String(data: data, encoding: .utf8) ?? "nil")
        return try JSONDecoder().decode(PlanRecommendationResponse.self, from: data)
    }

    // MARK: - 플랜 확정 저장 (단일 선택 저장)
    func savePlanSelection(_ request: PlanSelectionRequestDTO) async throws {
        _ = try await post(path: "/analysis/save", body: request)
    }

    func fetchLastPlan(userId: Int) async throws -> LastPlanResponse {
            // 1) URL 만들기: /analysis/last?userId=...
            var components = URLComponents(
                url: baseURL.appendingPathComponent("/analysis/last"),
                resolvingAgainstBaseURL: false
            )!
            components.queryItems = [
                URLQueryItem(name: "userId", value: String(userId))
            ]

            guard let url = components.url else {
                throw NSError(domain: "AnalysisAPI", code: -1, userInfo: [
                    NSLocalizedDescriptionKey: "잘못된 URL 입니다."
                ])
            }

            // 2) GET 요청
            let (data, response) = try await URLSession.shared.data(from: url)

            guard let http = response as? HTTPURLResponse,
                  200..<300 ~= http.statusCode else {
                throw NSError(
                    domain: "AnalysisAPI",
                    code: (response as? HTTPURLResponse)?.statusCode ?? -1,
                    userInfo: [NSLocalizedDescriptionKey: "최근 플랜 조회 실패"]
                )
            }

            // 3) JSON → LastPlanResponse 디코딩
            let decoder = JSONDecoder()
            // 백엔드가 camelCase 쓰고 있으니 strategy 는 기본값 그대로
            return try decoder.decode(LastPlanResponse.self, from: data)
        }

}
