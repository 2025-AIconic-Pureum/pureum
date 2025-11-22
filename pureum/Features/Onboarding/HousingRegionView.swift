//
//  HousingRegionView.swift
//  pureum
//

import SwiftUI

struct HousingRegionView: View {
    
    @EnvironmentObject var regionStore: RegionStore
    
    @State private var selectedSido: String = ""
    @State private var selectedSigungu: String = ""
    
    private let headerGreen = Color(red: 36/255, green: 178/255, blue: 40/255)
    
    var body: some View {
        ZStack {
            GreenHeaderBackground()
            
            VStack {
                Spacer().frame(height: 100)
                
                Text("현재 거주 지역을 알려주세요.")
                    .font(.title3)
                    .bold()
                    .padding(.horizontal, 24)
                    .frame(alignment: .leading)
                
                Text("실제 살고 있는 집의 시/도와 시·군·구를 선택해 주세요.")
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 24)
                
                // 시/도
                Picker("시/도", selection: $selectedSido) {
                    Text("시/도 선택").tag("")
                    ForEach(regionStore.regions.keys.sorted(), id: \.self) { sido in
                        Text(sido).tag(sido)
                    }
                }
                .pickerStyle(.menu)
                .padding()
                .frame(maxWidth: 280)
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .padding(.horizontal, 24)
                .padding(.bottom, 12)
                
                // 시·군·구
                Picker("시/군/구", selection: $selectedSigungu) {
                    Text("시/군/구 선택").tag("")
                    ForEach(regionStore.regions[selectedSido] ?? [], id: \.self) { sg in
                        Text(sg).tag(sg)
                    }
                }
                .pickerStyle(.menu)
                .padding()
                .frame(maxWidth: 280)
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
                
                NavigationLink(
                    destination: HousingTypeView()
                ) {
                    Text("다음")
                        .font(.headline)
                        .frame(maxWidth: 280)
                        .padding()
                        .background(isValid ? headerGreen : Color.gray.opacity(0.3))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .disabled(!isValid)
                
                Spacer()
            }
            .offset(y: 300)
        }
    }
    
    private var isValid: Bool {
        !selectedSido.isEmpty && !selectedSigungu.isEmpty
    }
}

#Preview {
    NavigationStack {
        HousingRegionView()
            .environmentObject(RegionStore())
    }
}
