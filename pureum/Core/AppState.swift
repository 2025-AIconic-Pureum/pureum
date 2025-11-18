//
//  AppState.swift
//  pureum
//
//  Created by 김수진 on 11/18/25.
//

import Foundation

final class AppState: ObservableObject {
    @Published var isLoggedIn: Bool = false
    @Published var finishedOnboarding: Bool = false
}
