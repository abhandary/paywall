//
//  LoadingView.swift
//  Paywall
//
//  Created by Akshay Bhandary on 8/17/22.
//

import Foundation

import SwiftUI

struct ActivityIndicator: UIViewRepresentable {

    @Binding var isAnimating: Bool
    let style: UIActivityIndicatorView.Style

    func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView {
        return UIActivityIndicatorView(style: style)
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicator>) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
    }
}

struct LoadingView: View {
  
  var body: some View {
    VStack() {
      ActivityIndicator(isAnimating: .constant(true), style: .large)
    }
  }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
      LoadingView()
    }
}
