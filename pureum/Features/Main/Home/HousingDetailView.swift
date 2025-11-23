//
//  HousingDetailView.swift
//  pureum
//
//  Created by 김수진 on 11/23/25.
//

import SwiftUI

struct HousingDetailView: View {
    let housing: HousingProfile
    
    private func formatWon(_ value: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return (formatter.string(from: NSNumber(value: value)) ?? "\(value)") + "원"
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                
                Text("주거 상세 정보")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 12)
                
                GroupBox {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("📍 지역")
                            .font(.headline)
                        Text("\(housing.regionSido) \(housing.regionSigungu)")
                    }
                    .padding(.vertical, 6)
                }
                
                GroupBox {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("🏠 주거 형태")
                            .font(.headline)
                        Text(housing.housingType)
                    }
                    .padding(.vertical, 6)
                }
                
                GroupBox {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("💰 보증금 / 월세")
                            .font(.headline)
                        Text("보증금: \(formatWon(housing.deposit))")
                        Text("월 주거비: \(formatWon(housing.monthlyCost))")
                    }
                    .padding(.vertical, 6)
                }
                
                Spacer(minLength: 40)
            }
            .padding()
        }
        .navigationTitle("주거 상세")
        .navigationBarTitleDisplayMode(.inline)
    }
}
