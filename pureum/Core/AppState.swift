//
//  AppState.swift
//  pureum
//
//  Created by 김수진 on 11/18/25.
//

import Foundation
import SwiftUI

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

final class AppState: ObservableObject {
    @Published var isLoggedIn: Bool = false
    @Published var finishedOnboarding: Bool = false

    // ✅ 새로 추가
    @Published var jobProfile: JobProfile?
    @Published var housingProfile: HousingProfile?
}
