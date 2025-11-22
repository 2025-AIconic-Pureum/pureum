//
//  RegionStore.swift
//  pureum
//
//  Created by 김수진 on 11/22/25.
//

import SwiftUI

// 시/도: [시군구] 형태
typealias RegionDict = [String: [String]]

final class RegionStore: ObservableObject {
    @Published var regions: RegionDict = [:]
    
    init() {
        load()
    }
    
    private func load() {
        guard let url = Bundle.main.url(
            forResource: "korea_regions", // 파일 이름
            withExtension: "json"
        ) else {
            print("⚠️ korea_regions.json 을 찾을 수 없습니다.")
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoded = try JSONDecoder().decode(RegionDict.self, from: data)
            self.regions = decoded
        } catch {
            print("⚠️ 지역 데이터 로드 실패:", error)
        }
    }
}
