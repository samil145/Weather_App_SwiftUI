//
//  LoadingView.swift
//  Weather-SwiftUI
//
//  Created by Shamil Bayramli on 09.06.24.
//

import SwiftUI

struct ActivityIndicator: UIViewRepresentable
{
    func makeUIView(context: Context) -> UIActivityIndicatorView {
        let activityIndicatorView = UIActivityIndicatorView(style: .large)
        activityIndicatorView.color = UIColor(named: "brandPrimary")
        activityIndicatorView.startAnimating()
        return activityIndicatorView
    }
    
    func updateUIView(_ uiView: UIActivityIndicatorView, context: Context) {}
}


struct LoadingView: View {
    var body: some View {
        ZStack
        {
            Color(.systemBackground)
                .ignoresSafeArea(edges: .all)
            
            ActivityIndicator()
            
        }
    }
}
