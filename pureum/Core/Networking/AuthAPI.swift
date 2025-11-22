//
//  AuthAPI.swift
//  pureum
//
//  Created by 김수진 on 11/22/25.
//

// AuthAPI.swift

import Foundation

enum AuthAPIError: Error, LocalizedError {
    case invalidURL
    case serverError(String)
    case decodingError
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "잘못된 서버 주소입니다."
        case .serverError(let msg):
            return msg
        case .decodingError:
            return "서버 응답을 해석할 수 없습니다."
        case .unknown:
            return "알 수 없는 오류가 발생했습니다."
        }
    }
}

struct AuthAPI {
    
    // 시뮬레이터에서 테스트 시:
    // - Mac에서 서버: "http://localhost:8080"
    // - 실제 아이폰에서 Mac 서버 접속: "http://<내 IP>:8080"
    static let baseURL = "http://localhost:8080"
    
    static func register(email: String,
                         password: String,
                         name: String) async throws -> AuthResponseDTO {
        guard let url = URL(string: "\(baseURL)/auth/register") else {
            throw AuthAPIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json",
                         forHTTPHeaderField: "Content-Type")
        
        let body: [String: String] = [
            "email": email,
            "password": password,
            "name": name
        ]
        
        request.httpBody = try JSONEncoder().encode(body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        if let http = response as? HTTPURLResponse,
           !(200..<300).contains(http.statusCode) {
            let msg = String(data: data, encoding: .utf8) ?? "서버 오류"
            throw AuthAPIError.serverError(msg)
        }
        
        do {
            let decoded = try JSONDecoder().decode(AuthResponseDTO.self, from: data)
            return decoded
        } catch {
            print("Decoding error:", error)
            throw AuthAPIError.decodingError
        }
    }
    
    static func login(email: String,
                      password: String) async throws -> AuthResponseDTO {
        guard let url = URL(string: "\(baseURL)/auth/login") else {
            throw AuthAPIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json",
                         forHTTPHeaderField: "Content-Type")
        
        let body: [String: String] = [
            "email": email,
            "password": password
        ]
        
        request.httpBody = try JSONEncoder().encode(body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        if let http = response as? HTTPURLResponse,
           !(200..<300).contains(http.statusCode) {
            let msg = String(data: data, encoding: .utf8) ?? "서버 오류"
            throw AuthAPIError.serverError(msg)
        }
        
        do {
            let decoded = try JSONDecoder().decode(AuthResponseDTO.self, from: data)
            return decoded
        } catch {
            print("Decoding error:", error)
            throw AuthAPIError.decodingError
        }
    }
}
