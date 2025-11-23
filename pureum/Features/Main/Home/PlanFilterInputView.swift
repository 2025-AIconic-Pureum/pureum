//
//  PlanFilterInputView.swift
//  pureum
//
//  Created by 김수진 on 11/23/25.
//
import SwiftUI

/// AI 플랜 추천을 위한 조건 입력 화면
struct PlanFilterInputView: View {
    let mode: AnalysisMode
    let houseCandidates: [HouseCandidate]
    let jobCandidates: [JobCandidate]

    @EnvironmentObject var regionStore: RegionStore

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

    // MARK: - 결과 / 상태
    @State private var isLoading: Bool = false
    @State private var resultText: String = ""
    @State private var errorMessage: String?

    // MARK: - 상수 배열들

    // 직종 리스트
    private let categories = [
        "기획·전략",
        "마케팅·홍보·조사",
        "회계·세무·재무",
        "인사·노무·HRD",
        "총무·법무·사무",
        "IT개발·데이터",
        "디자인",
        "영업·판매·무역",
        "고객상담·TM",
        "구매·자재·물류",
        "상품기획·MD",
        "운전·운송·배송",
        "서비스",
        "생산",
        "건설·건축",
        "의료",
        "연구·R&D",
        "교육",
        "미디어·문화·스포츠",
        "금융·보험",
        "공공·복지"
    ]

    // 주거 형태 목록
    private let housingTypes = [
        "원룸 / 오피스텔",
        "기숙사",
        "쉐어하우스",
        "공공임대",
        "아파트",
        "기타"
    ]

    // 고용 형태
    private let retypes = [
        "전체",
        "정규직",
        "계약직",
        "아르바이트",
        "인턴",
        "프리랜서",
        "기타"
    ]

    // 경력
    private let careers = [
        "무관",
        "신입",
        "1~3년",
        "3~5년",
        "5년 이상"
    ]

    // 학력
    private let educations = [
        "무관",
        "고졸",
        "초대졸",
        "대졸",
        "석사 이상"
    ]

    // MARK: - Body

    var body: some View {
        Form {
            // MARK: - 주거 조건 섹션
            if mode == .houseJob || mode == .house {
                Section(header: Text("주거 조건")) {
                    Picker("주거 형태", selection: $selectedHousingType) {
                        ForEach(housingTypes, id: \.self) { type in
                            Text(type).tag(type)
                        }
                    }

                    // 도시 선택
                    Picker("주거 도시", selection: $selectedHousingCity) {
                        ForEach(cities, id: \.self) { city in
                            Text(city).tag(city)
                        }
                    }

                    // 구/군 선택 (선택된 도시 기준)
                    Picker("주거 구/군", selection: $selectedHousingDistrict) {
                        ForEach(districts(for: selectedHousingCity), id: \.self) { gu in
                            Text(gu).tag(gu)
                        }
                    }

                    TextField("최대 보증금 (원)", text: $maxDeposit)
                        .keyboardType(.numberPad)

                    TextField("최대 월 주거비 (원)", text: $maxMonthlyCost)
                        .keyboardType(.numberPad)
                }
            }

            // MARK: - 일자리 조건 섹션
            if mode == .houseJob || mode == .job {
                Section(header: Text("일자리 조건")) {
                    Picker("직종", selection: $selectedJobCategory) {
                        ForEach(categories, id: \.self) { cat in
                            Text(cat).tag(cat)
                        }
                    }

                    // 도시 선택
                    Picker("일자리 도시", selection: $selectedJobCity) {
                        ForEach(cities, id: \.self) { city in
                            Text(city).tag(city)
                        }
                    }

                    // 구/군 선택
                    Picker("일자리 구/군", selection: $selectedJobDistrict) {
                        ForEach(districts(for: selectedJobCity), id: \.self) { gu in
                            Text(gu).tag(gu)
                        }
                    }

                    Picker("고용 형태", selection: $selectedRetype) {
                        ForEach(retypes, id: \.self) { type in
                            Text(type).tag(type)
                        }
                    }

                    TextField("최소 월급 (원)", text: $minSalary)
                        .keyboardType(.numberPad)

                    Picker("경력", selection: $selectedCareer) {
                        ForEach(careers, id: \.self) { c in
                            Text(c).tag(c)
                        }
                    }

                    Picker("학력", selection: $selectedEducation) {
                        ForEach(educations, id: \.self) { e in
                            Text(e).tag(e)
                        }
                    }
                }
            }

            // MARK: - 실행 버튼 섹션
            Section {
                Button {
                    Task { await runAnalysis() }
                } label: {
                    HStack {
                        if isLoading {
                            ProgressView()
                        }
                        Text("AI 플랜 분석하기")
                            .fontWeight(.semibold)
                    }
                }
                .disabled(isLoading)
            }

            // MARK: - 에러 메시지
            if let error = errorMessage {
                Section(header: Text("에러").foregroundColor(.red)) {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.footnote)
                }
            }

            // MARK: - 결과 표시
            if !resultText.isEmpty {
                Section(header: Text("추천 결과")) {
                    Text(resultText)
                        .font(.subheadline)
                }
            }
        }
        .navigationTitle(titleForMode(mode))
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            setupDefaults()
        }
    }

    // MARK: - RegionStore 헬퍼

    /// ["대구": ["북구","수성구"], "서울": ["관악구","강남구"]] 에서 도시 리스트만 뽑기
    private var cities: [String] {
        regionStore.regions.keys.sorted()
    }

    /// 선택된 도시의 구/군 리스트
    private func districts(for city: String) -> [String] {
        regionStore.regions[city] ?? []
    }

    /// 주거 location 문자열 (예: "대구 북구")
    private var housingLocation: String {
        selectedHousingCity.isEmpty || selectedHousingDistrict.isEmpty
        ? ""
        : "\(selectedHousingCity) \(selectedHousingDistrict)"
    }

    /// 일자리 location 문자열 (예: "대구 수성구")
    private var jobLocation: String {
        selectedJobCity.isEmpty || selectedJobDistrict.isEmpty
        ? ""
        : "\(selectedJobCity) \(selectedJobDistrict)"
    }

    // MARK: - 초기 선택값 세팅

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

    // MARK: - 타이틀

    private func titleForMode(_ mode: AnalysisMode) -> String {
        switch mode {
        case .houseJob: return "일자리 + 주거 플랜"
        case .house:    return "주거 플랜"
        case .job:      return "일자리 플랜"
        }
    }

    // MARK: - 실제 분석 호출 (나중에 서버 연동 자리)

    private func runAnalysis() async {
        await MainActor.run {
            isLoading = true
            errorMessage = nil
            resultText = ""
        }

        // TODO: 여기서 houseCandidates / jobCandidates + 선택한 조건들
        //       (housingLocation, jobLocation, selectedJobCategory, etc.)
        //       서버로 POST 하면 됨.

        // 지금은 디버그용 더미 딜레이 & 결과
        try? await Task.sleep(nanoseconds: 800_000_000)

        await MainActor.run {
            isLoading = false
            resultText = """
            [디버그용 더미 결과]

            모드: \(titleForMode(mode))

            ▶ 주거 조건
            도시: \(selectedHousingCity)
            구/군: \(selectedHousingDistrict)
            location: \(housingLocation)
            주거 형태: \(selectedHousingType)
            최대 보증금: \(maxDeposit)
            최대 월 주거비: \(maxMonthlyCost)

            ▶ 일자리 조건
            도시: \(selectedJobCity)
            구/군: \(selectedJobDistrict)
            location: \(jobLocation)
            직종: \(selectedJobCategory)
            고용 형태: \(selectedRetype)
            최소 월급: \(minSalary)
            경력: \(selectedCareer)
            학력: \(selectedEducation)
            """
        }
    }
}
