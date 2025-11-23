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

final class AnalysisAPI {
    static let shared = AnalysisAPI()
    private init() {}

    private let baseURL = URL(string: "http://localhost:8080")! // 서버 주소 변경

    private func post<Request: Encodable>(
        path: String,
        body: Request
    ) async throws -> String {

        let url = baseURL.appendingPathComponent(path)
        var request = URLRequest(url: url)

        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .useDefaultKeys
        request.httpBody = try encoder.encode(body)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              200..<300 ~= httpResponse.statusCode else {
            throw NSError(domain: "AnalysisAPI",
                          code: (response as? HTTPURLResponse)?.statusCode ?? -1,
                          userInfo: nil)
        }

        return String(data: data, encoding: .utf8) ?? ""
    }

    // MARK: - 집 + 일자리 추천
    func recommendHouseJob(
        houses: [HouseCandidate],
        jobs: [JobCandidate]
    ) async throws -> String {
        let body = HouseJobRequest(houses: houses, jobs: jobs)
        return try await post(path: "/analysis/house_job", body: body)
    }

    // MARK: - 집만 추천
    func recommendHouseOnly(houses: [HouseCandidate]) async throws -> String {
        let body = HouseOnlyRequest(houses: houses)
        return try await post(path: "/analysis/house", body: body)
    }

    // MARK: - 일자리만 추천
    func recommendJobOnly(jobs: [JobCandidate]) async throws -> String {
        let body = JobOnlyRequest(jobs: jobs)
        return try await post(path: "/analysis/job", body: body)
    }
}
