//
//  NoConnectionView.swift
//  Weather-SwiftUI
//
//  Created by Shamil Bayramli on 10.06.24.
//

import SwiftUI

struct NoConnectionView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var viewModel: WeatherMainViewModel
    @Binding var isRetryLoading: Bool
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea(.all)
            
            VStack
            {
                ZStack
                {
                    SlantedShape()
                        .fill(Color.red)
                        .frame(height: UIScreen.main.bounds.height/2)
                        .edgesIgnoringSafeArea(.top)
                    
                    Image(systemName: "wifi.slash")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundStyle(.white, .secondaryState)
                        .frame(width: 220, height: 220)
                }
                
                Text("Whoops!")
                    .font(.system(size: 40, weight: .semibold))
                    .offset(y: -65)
                
                Text("No Internet Connection found.")
                    .frame(width: UIScreen.main.bounds.width)
                    .font(.system(size: 25, weight: .medium))
                    .multilineTextAlignment(.center)
                    .padding(3)
                    .fixedSize(horizontal: false, vertical: true)
                
                Text("Check your connection or try again.")
                    .frame(width: UIScreen.main.bounds.width)
                    .font(.system(size: 25, weight: .medium))
                    .multilineTextAlignment(.center)
                    .padding(3)
                    .fixedSize(horizontal: false, vertical: true)
                
                
                Spacer()
                
                Button
                {
                    viewModel.recreateLocationManager()
                    isRetryLoading = true
                    //viewModel.getForecasts()
                    //viewModel.isNoConnection = false
                } label: {
                    Text("Retry")
                        .font(.title2)
                        .fontWeight(.bold)
                        .frame(width: 150, height: 50)
                        .foregroundStyle((colorScheme == .light) ? .white : .black)
                        .background((colorScheme == .light) ? Color.black : Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .padding(.bottom, 30)
                
            }
            
            if (isRetryLoading)
            {
                LoadingView()
            }
        }
            
    }
}

#Preview {
    NoConnectionView(isRetryLoading: .constant(false))
}


struct SlantedShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: rect.height))
        path.addLine(to: CGPoint(x: 0, y: rect.height * 0.85))
        path.closeSubpath()
        return path
    }
}
