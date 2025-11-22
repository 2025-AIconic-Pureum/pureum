//
//  JobCheckView.swift
//  pureum
//
//  Created by 김수진 on 11/22/25.
//

import SwiftUI

struct JobCheckView: View {
    
    private let headerGreen = Color(red: 36/255, green: 178/255, blue: 40/255)
    
    var body: some View {
        ZStack {
            GreenHeaderBackground()
            VStack {
                Spacer().frame(height: 100)
                
                Text("현재 일자리가 있으신가요?")
                    .font(.title3)
                    .bold()
                    .padding(.horizontal, 24)
                    .frame(alignment: .leading)
                    
                
                Text("정확한 분석을 위해 알려주세요.")
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 30)
                    
                
                NavigationLink(destination: JobCategorySelectView()) {
                    Text("있어요")
                        .font(.headline)
                        .frame(maxWidth: 280)
                        .padding()
                        .background(headerGreen)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 12)
                
                
                NavigationLink(destination: HousingCheckView()) {
                    Text("없어요")
                        .font(.headline)
                        .frame(maxWidth: 280)
                        .padding()
                        .background(Color(red: 240/255, green: 240/255, blue: 240/255))
                        .foregroundColor(.black)
                        .cornerRadius(12)
                }

                .padding(.horizontal, 24)
                
                Spacer()
            }
            .offset(x: 0, y: 300)
        }
    }
}

#Preview {
    JobCheckView()
}
