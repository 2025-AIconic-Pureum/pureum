//
//  JobHousingPlanStartView.swift
//  pureum
//

import SwiftUI

struct JobHousingPlanStartView: View {
    
    @EnvironmentObject var appState: AppState
    
    private let headerGreen = Color(red: 36/255, green: 178/255, blue: 40/255)
    private let lightGreen  = Color(red: 230/255, green: 245/255, blue: 235/255)
    
    var hasJob: Bool { appState.jobProfile != nil }
    var hasHouse: Bool { appState.housingProfile != nil }
    
    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    
                    // MARK: - 제목
                    VStack(alignment: .leading, spacing: 4) {
                        Text("일자리·주거 플랜")
                            .font(.largeTitle)
                            .fontWeight(.heavy)
                        
                        Text("지금 정보를 그대로 쓸지, 처음부터 다시 설계할지 선택해 주세요.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 24)
                    .padding(.horizontal, 20)
                    
                    // MARK: - 현재 저장된 정보 요약 (있을 때만)
                    if hasJob || hasHouse {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("현재 저장된 정보")
                                .font(.headline)
                            
                            if let job = appState.jobProfile {
                                VStack(alignment: .leading, spacing: 6) {
                                    Text("일자리")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                    
                                    Text("\(job.category) · \(job.jobType)")
                                        .font(.headline)
                                    
                                    Text("\(job.regionSido) \(job.regionSigungu)")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    
                                    Text("월 소득 약 \(job.monthlyIncome)원")
                                        .font(.caption2)
                                        .foregroundColor(.secondary)
                                }
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.white)
                                .cornerRadius(16)
                            } else {
                                Text("저장된 일자리 정보가 없어요.")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                    .padding()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(Color.white)
                                    .cornerRadius(16)
                            }
                            
                            if let house = appState.housingProfile {
                                VStack(alignment: .leading, spacing: 6) {
                                    Text("주거")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                    
                                    Text(house.housingType)
                                        .font(.headline)
                                    
                                    Text("\(house.regionSido) \(house.regionSigungu)")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    
                                    Text("월 고정 주거비 약 \(house.monthlyCost)원")
                                        .font(.caption2)
                                        .foregroundColor(.secondary)
                                }
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.white)
                                .cornerRadius(16)
                            } else {
                                Text("저장된 주거 정보가 없어요.")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                    .padding()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(Color.white)
                                    .cornerRadius(16)
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    
                    // MARK: - 선택 버튼들
                    VStack(alignment: .leading, spacing: 12) {
                        Text("어떻게 플랜을 만들까요?")
                            .font(.headline)
                            .padding(.horizontal, 20)
                        
                        // ✅ 1) 지금 정보 그대로 사용
                        if hasJob || hasHouse {
                            NavigationLink(
                                destination: AnalyzingView()
                                    .navigationBarBackButtonHidden(true)
                            ) {
                                HStack(alignment: .top, spacing: 12) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.title2)
                                        .foregroundColor(headerGreen)
                                        .padding(.top, 2)
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("현재 정보 그대로 사용할게요")
                                            .font(.headline)
                                            .foregroundColor(.black)
                                        
                                        Text("지금 저장된 일자리·주거 정보를 기반으로 바로 플랜을 분석해 드려요.")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                            .fixedSize(horizontal: false, vertical: true)
                                    }
                                    
                                    Spacer()
                                }
                                .padding()
                                .background(headerGreen.opacity(0.12))
                                .cornerRadius(20)
                            }
                            .buttonStyle(.plain)
                            .padding(.horizontal, 20)
                        }
                        
                        // ✅ 2) 처음부터 다시 입력
                        NavigationLink(
                            destination: JobCheckView()
                                .navigationBarBackButtonHidden(true)
                        ) {
                            HStack(alignment: .top, spacing: 12) {
                                Image(systemName: "pencil.and.outline")
                                    .font(.title2)
                                    .foregroundColor(.black)
                                    .padding(.top, 2)
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("처음부터 다시 입력할래요")
                                        .font(.headline)
                                        .foregroundColor(.black)
                                    
                                    Text("일자리, 소득, 주거 정보를 단계별로 다시 입력하면서 새로운 플랜을 만들 수 있어요.")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                        .fixedSize(horizontal: false, vertical: true)
                                }
                                
                                Spacer()
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(20)
                            .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 2)
                        }
                        .buttonStyle(.plain)
                        .padding(.horizontal, 20)
                    }
                    
                    Spacer(minLength: 40)
                }
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        JobHousingPlanStartView()
            .environmentObject(AppState())
    }
}
