//
//  AuthResponseDTO.swift
//  pureum
//
//  Created by 김수진 on 11/22/25.
//

// AuthResponseDTO.swift

import Foundation

struct AuthResponseDTO: Codable {
    let userId: Int
    let hasOnboarded: Bool
    let accessToken: String
}

