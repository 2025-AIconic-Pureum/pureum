//
//  PlanFilterInputView.swift
//  pureum
//

import SwiftUI

/// AI 플랜 추천을 위한 조건 입력 화면
struct PlanFilterInputView: View {
    let mode: AnalysisMode
    let houseCandidates: [HouseCandidate]
    let jobCandidates: [JobCandidate]

    @EnvironmentObject var regionStore: RegionStore
    @EnvironmentObject var appState: AppState

    // MARK: - 주거 조건 상태
    @State private var selectedHousingType: String = ""
    @State private var selectedHousingCity: String = ""
    @State private var selectedHousingDistrict: String = ""
    @State private var maxDeposit: String = ""
    @State private var maxMonthlyCost: String = ""

    // MARK: - 일자리 조건 상태
    @State private var selectedJobCategory: String = ""
    @State private var selectedJobCity: String = ""
    @State private var selectedJobDistrict: String = ""
    @State private var selectedRetype: String = "전체"
    @State private var minSalary: String = ""
    @State private var selectedCareer: String = "무관"
    @State private var selectedEducation: String = "무관"

    // MARK: - 상태
    @State private var isLoading: Bool = false
    @State private var result: PlanRecommendationResponse?
    @State private var errorMessage: String?

    // 저장 성공/실패 알림
    @State private var showSaveSuccess = false
    @State private var showSaveError = false

    // MARK: - Constants
    private let categories = [
        "기획·전략", "마케팅·홍보·조사", "회계·세무·재무", "인사·노무·HRD",
        "총무·법무·사무", "IT개발·데이터", "디자인", "영업·판매·무역",
        "고객상담·TM", "구매·자재·물류", "상품기획·MD", "운전·운송·배송",
        "서비스", "생산", "건설·건축", "의료", "연구·R&D",
        "교육", "미디어·문화·스포츠", "금융·보험", "공공·복지"
    ]

    private let housingTypes = [
        "원룸 / 오피스텔", "기숙사", "쉐어하우스",
        "공공임대", "아파트", "기타"
    ]

    private let retypes = [
        "전체", "정규직", "계약직", "아르바이트",
        "인턴", "프리랜서", "기타"
    ]

    private let careers = [
        "무관", "신입", "1~3년", "3~5년", "5년 이상"
    ]

    private let educations = [
        "무관", "고졸", "초대졸", "대졸", "석사 이상"
    ]

    // MARK: - Body

    var body: some View {
        Form {
            if mode != .job { housingSection }
            if mode != .house { jobSection }

            runButtonSection

            if let error = errorMessage {
                errorSection(error)
            }

            resultSection
        }
        .navigationTitle(titleForMode(mode))
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { setupDefaults() }
        .alert("플랜 저장 완료!", isPresented: $showSaveSuccess) {
            Button("확인", role: .cancel) { }
        }
        .alert("저장 실패", isPresented: $showSaveError) {
            Button("확인", role: .cancel) { }
        }
    }
    
    private func titleForMode(_ mode: AnalysisMode) -> String {
        switch mode {
        case .houseJob: return "일자리 + 주거 플랜"
        case .house:    return "주거 플랜"
        case .job:      return "일자리 플랜"
        }
    }


    // MARK: - Sections

    @ViewBuilder
    private var housingSection: some View {
        Section(header: Text("주거 조건")) {
            Picker("주거 형태", selection: $selectedHousingType) {
                ForEach(housingTypes, id: \.self) { Text($0) }
            }
            Picker("도시", selection: $selectedHousingCity) {
                ForEach(cities, id: \.self) { Text($0) }
            }
            Picker("구/군", selection: $selectedHousingDistrict) {
                ForEach(districts(for: selectedHousingCity), id: \.self) { Text($0) }
            }
            TextField("최대 보증금 (원)", text: $maxDeposit)
                .keyboardType(.numberPad)
            TextField("최대 월 주거비 (원)", text: $maxMonthlyCost)
                .keyboardType(.numberPad)
        }
    }

    @ViewBuilder
    private var jobSection: some View {
        Section(header: Text("일자리 조건")) {
            Picker("직종", selection: $selectedJobCategory) {
                ForEach(categories, id: \.self) { Text($0) }
            }

            Picker("도시", selection: $selectedJobCity) {
                ForEach(cities, id: \.self) { Text($0) }
            }

            Picker("구/군", selection: $selectedJobDistrict) {
                ForEach(districts(for: selectedJobCity), id: \.self) { Text($0) }
            }

            Picker("고용 형태", selection: $selectedRetype) {
                ForEach(retypes, id: \.self) { Text($0) }
            }

            TextField("최소 월급 (원)", text: $minSalary)
                .keyboardType(.numberPad)

            Picker("경력", selection: $selectedCareer) {
                ForEach(careers, id: \.self) { Text($0) }
            }

            Picker("학력", selection: $selectedEducation) {
                ForEach(educations, id: \.self) { Text($0) }
            }
        }
    }

    private var runButtonSection: some View {
        Section {
            Button {
                Task { await runAnalysis() }
            } label: {
                HStack {
                    if isLoading { ProgressView() }
                    Text("AI 플랜 분석하기")
                }
            }
            .disabled(isLoading)
        }
    }

    private func errorSection(_ error: String) -> some View {
        Section(header: Text("에러").foregroundColor(.red)) {
            Text(error).foregroundColor(.red)
        }
    }

    // MARK: - 결과 출력

    @ViewBuilder
    private var resultSection: some View {
        if let res = result {
            Section(header: Text("추천 결과")) {
                ForEach(res.combos) { combo in
                    comboCard(combo)
                }

                Button("이 결과 저장하기") {
                    Task { await savePlan() }
                }
            }
        }
    }

    private func comboCard(_ combo: PlanRecommendationItem) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("⭐️ \(combo.rank)위")
                .font(.subheadline).bold()

            // 집 정보
            if mode != .job {
                VStack(alignment: .leading) {
                    Text("🏠 집: \(combo.house.name)")
                    Text(combo.house.locationDisplay)
                    Text("보증금: \(combo.house.depositDisplay)")
                    Text("월세: \(combo.house.rentFeeDisplay)")
                }
                .font(.footnote)
            }

            // 일자리 정보
            if mode != .house {
                VStack(alignment: .leading) {
                    Text("💼 일자리: \(combo.job.title)")
                    Text(combo.job.company)
                    Text(combo.job.location)
                    Text("급여: \(combo.job.salaryDisplay)")
                }
                .font(.footnote)
            }

            Text("📝 이유: \(combo.reason)")
                .font(.footnote)
                .foregroundColor(.secondary)
        }
        .padding(10)
        .background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemGray6)))
    }

    // MARK: - 지역 헬퍼

    private var cities: [String] {
        Array(regionStore.regions.keys).sorted()
    }

    private func districts(for city: String) -> [String] {
        regionStore.regions[city] ?? []
    }

    // MARK: - 초기값 설정

    private func setupDefaults() {
        if selectedHousingType.isEmpty {
            selectedHousingType = housingTypes.first ?? ""
        }
        if selectedJobCategory.isEmpty {
            selectedJobCategory = categories.first ?? ""
        }

        if let firstCity = cities.first {
            if selectedHousingCity.isEmpty {
                selectedHousingCity = firstCity
                selectedHousingDistrict = districts(for: firstCity).first ?? ""
            }
            if selectedJobCity.isEmpty {
                selectedJobCity = firstCity
                selectedJobDistrict = districts(for: firstCity).first ?? ""
            }
        }
    }

    // MARK: - 추천 호출

    private func runAnalysis() async {
        isLoading = true
        errorMessage = nil
        result = nil

        do {
            let filteredHouses = self.filteredHouses()
            let filteredJobs = self.filteredJobs()

            switch mode {
            case .houseJob:
                self.result = try await AnalysisAPI.shared.recommendHouseJob(
                    houses: filteredHouses,
                    jobs: filteredJobs
                )
            case .house:
                self.result = try await AnalysisAPI.shared.recommendHouseOnly(
                    houses: filteredHouses
                )
            case .job:
                self.result = try await AnalysisAPI.shared.recommendJobOnly(
                    jobs: filteredJobs
                )
            }

            isLoading = false
        } catch {
            isLoading = false
            errorMessage = error.localizedDescription
        }
    }

    // MARK: - 필터링

    private func filteredHouses() -> [HouseCandidate] {
        var result = houseCandidates

        if !selectedHousingCity.isEmpty {
            result = result.filter { $0.location.contains(selectedHousingCity) }
        }
        if !selectedHousingDistrict.isEmpty {
            result = result.filter { $0.location.contains(selectedHousingDistrict) }
        }

        if let maxDepositInt = Int(maxDeposit.filter(\.isNumber)), maxDepositInt > 0 {
            result = result.filter { $0.deposit <= maxDepositInt }
        }
        if let maxMonthlyInt = Int(maxMonthlyCost.filter(\.isNumber)), maxMonthlyInt > 0 {
            result = result.filter { $0.monthlyCost <= maxMonthlyInt }
        }

        return result
    }

    private func filteredJobs() -> [JobCandidate] {
        var result = jobCandidates

        if !selectedJobCity.isEmpty {
            result = result.filter { $0.location.contains(selectedJobCity) }
        }
        if !selectedJobDistrict.isEmpty {
            result = result.filter { $0.location.contains(selectedJobDistrict) }
        }

        if !selectedJobCategory.isEmpty {
            result = result.filter { $0.jobCategory == selectedJobCategory }
        }

        if selectedRetype != "전체" {
            result = result.filter { $0.retype == selectedRetype }
        }

        if let minSalaryInt = Int(minSalary.filter(\.isNumber)), minSalaryInt > 0 {
            result = result.filter { $0.salary >= minSalaryInt }
        }

        return result
    }

    // MARK: - 저장 요청

    
    private func savePlan() async {
        guard let userId = appState.userId else {
            errorMessage = "로그인 후 이용해주세요."
            return
        }
        guard let result = result else { return }

        do {
            // 🔥 combos 전부 저장
            for combo in result.combos {
                let houseId: String?
                let jobId: String?

                switch mode {
                case .houseJob:
                    houseId = combo.house.id
                    jobId = combo.job.id
                case .house:
                    houseId = combo.house.id
                    jobId = nil
                case .job:
                    houseId = nil
                    jobId = combo.job.id
                }

                let req = PlanSelectionRequestDTO(
                    userId: userId,
                    rank: combo.rank,
                    houseId: houseId,
                    jobId: jobId,
                    reason: combo.reason
                )

                try await AnalysisAPI.shared.savePlanSelection(req)
            }

            showSaveSuccess = true

        } catch {
            showSaveError = true
        }
    }



    private func modeString() -> String {
        switch mode {
        case .houseJob: return "HOUSE_JOB"
        case .house: return "HOUSE"
        case .job: return "JOB"
        }
    }
}
