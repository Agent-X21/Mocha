//
//  SplashScreenView.swift
//  Mocha
//
//  Created by Zane Duncan on 9/7/25.
//


import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false
    @State private var scale: CGFloat = 0.5
    @State private var opacity: Double = 0.0
    
    var body: some View {
        if isActive {
            ContentView()
        } else {
            ZStack {
                Color.black
                    .ignoresSafeArea()
                
                Image("splash")
                    .resizable()
                    .scaledToFill()
                    .frame(width: UIScreen.main.bounds.width,
                           height: UIScreen.main.bounds.height) // force full screen
                    .clipped() // crop overflow if necessary
                    .scaleEffect(scale)
                    .opacity(opacity)
                    .onAppear {
                        withAnimation(.easeInOut(duration: 0.0)) {
                            scale = 1.0
                            opacity = 1.0
                        }
                        
                        // Auto-dismiss after 5 seconds
                        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                opacity = 0.0
                            }
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                isActive = true
                            }
                        }
                    }
            }
            .ignoresSafeArea()

        }
    }
}

#Preview {
    SplashScreenView()
}
