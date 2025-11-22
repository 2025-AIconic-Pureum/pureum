//
//  UserAPI.swift
//  pureum
//
//  Created by 김수진 on 11/22/25.
//

// UserAPI.swift

import Foundation

enum APIError: Error {
    case invalidURL
    case badStatus(Int)
    case noData
    case decoding(Error)
}

struct UserAPI {
    static func fetchProfile(
        userId: Int,
        token: String,
        completion: @escaping (Result<UserProfileResponseDTO, Error>) -> Void
    ) {
        // 👉 실제 서버 URL에 맞게 바꿔줘야 함
        // 예: GET /users/{id}/profile
        guard let url = URL(string: "http://localhost:8080/users/\(userId)/profile") else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let http = response as? HTTPURLResponse else {
                completion(.failure(APIError.noData))
                return
            }
            
            guard (200...299).contains(http.statusCode) else {
                completion(.failure(APIError.badStatus(http.statusCode)))
                return
            }
            
            guard let data = data else {
                completion(.failure(APIError.noData))
                return
            }
            
            do {
                let decoded = try JSONDecoder().decode(UserProfileResponseDTO.self, from: data)
                completion(.success(decoded))
            } catch {
                completion(.failure(APIError.decoding(error)))
            }
        }.resume()
    }
}



