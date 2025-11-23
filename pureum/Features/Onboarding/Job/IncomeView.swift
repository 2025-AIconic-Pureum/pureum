//
//  IncomeView.swift
//  pureum
//
import SwiftUI

struct IncomeView: View {
    
    @EnvironmentObject var appState: AppState      // ✅ AppState 주입
    @State private var income: String = ""
    @FocusState private var isInputFocused: Bool
    
    let job: String      // "없음" 또는 "IT개발·데이터 / 정규직"
    
    private let headerGreen = Color(red: 36/255, green: 178/255, blue: 40/255)
    
    var body: some View {
        ZStack {
            GreenHeaderBackground()
            
            VStack {
                Spacer().frame(height: 100)
                
                Text("월 소득을 알려주세요.")
                    .font(.title3)
                    .bold()
                    .padding(.horizontal, 24)
                    .frame(alignment: .leading)
                
                Text(job == "없음"
                     ? "현재 받는 소득이 없다면 0원을 입력해 주세요."
                     : "\(job) 기준 월 소득을 입력해 주세요.")
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 24)
                
                TextField("예: 1,500,000", text: $income)
                    .keyboardType(.numberPad)
                    .focused($isInputFocused)
                    .padding()
                    .frame(maxWidth: 280)
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 20)
                
                // ✅ 월 소득 저장 후 → 주거 체크 화면
                NavigationLink(destination: HousingCheckView()) {
                    Text("다음")
                        .font(.headline)
                        .frame(maxWidth: 280)
                        .padding()
                        .background(headerGreen)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .padding(.horizontal, 24)
                .simultaneousGesture(TapGesture().onEnded {
                    let incomeInt = Int(income) ?? 0
                    
                    if var jobProfile = appState.jobProfile {
                        // 이미 region / category / type 설정돼 있으면 income만 채우기
                        jobProfile.monthlyIncome = incomeInt
                        appState.jobProfile = jobProfile
                    } else {
                        // 혹시라도 앞단에서 jobProfile을 못 채운 경우를 대비한 fallback
                        let parts = job.split(separator: "/").map { $0.trimmingCharacters(in: .whitespaces) }
                        let category = parts.first ?? "기타"
                        let type = parts.count > 1 ? parts[1] : "기타"
                        
                        appState.jobProfile = JobProfile(
                            category: String(category),
                            jobType: String(type),
                            regionSido: "",
                            regionSigungu: "",
                            monthlyIncome: incomeInt
                        )
                    }
                    
                    print("📌 저장된 jobProfile:", appState.jobProfile as Any)
                })
                
                Spacer()
            }
            .offset(y: isInputFocused ? 80 : 230)
                        .animation(.easeOut(duration: 0.25), value: isInputFocused)
        }
    }
}

#Preview {
    NavigationStack {
        IncomeView(job: "IT개발·데이터 / 정규직")
            .environmentObject(AppState())
    }
}
