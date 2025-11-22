//
//  OnboardingAPI.swift
//  pureum
//
//  Created by 김수진 on 11/22/25.
//

import Foundation

struct OnboardingAPI {
    static func submitOnboarding(
        dto: OnboardingProfileRequestDTO,
        token: String,
        completion: @escaping (Bool) -> Void
    ) {
        guard let url = URL(string: "http://localhost:8080/onboarding/submit") else {
            completion(false)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        do {
            request.httpBody = try JSONEncoder().encode(dto)
        } catch {
            print("Encoding error:", error)
            completion(false)
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let http = response as? HTTPURLResponse {
                print("📡 STATUS:", http.statusCode)

                if (200...299).contains(http.statusCode) {
                    completion(true)
                    return
                }
            }

            if let data = data,
               let body = String(data: data, encoding: .utf8) {
                print("❌ RESPONSE BODY:", body)
            }

            if let error = error {
                print("❌ URLSession Error:", error)
            }

            completion(false)
        }.resume()

        
        
    }
}
