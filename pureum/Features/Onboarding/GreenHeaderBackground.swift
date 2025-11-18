//
//  GreenHeaderBackground.swift
//  pureum
//
//  Created by 김수진 on 11/18/25.
//

import SwiftUI

struct GreenHeaderBackground: View {
    var body: some View {
        ZStack {
            Color.white
            VStack(spacing: 0) {
                Circle()
                    .fill(Color.green)
                    .frame(width: 400, height: 400)
                    .offset(x: 120, y: -200)
                Spacer()
            }
        }
        .ignoresSafeArea()
    }
}
