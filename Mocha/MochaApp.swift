//
//  MochaApp.swift
//  Mocha
//
//  Created by Zane Duncan on 8/28/25.
//

import SwiftUI

@main
struct MochaApp: App {
    var body: some Scene {
        WindowGroup {
            SplashScreenView()
                .preferredColorScheme(.dark) // Force dark mode
                .onAppear {
                    // Configure app appearance
                    configureAppearance()
                }
        }
    }
    
    private func configureAppearance() {
        // Set up iOS 26+ specific configurations
        if #available(iOS 26.0, *) {
            // Enable new iOS 26 features
            // This will be expanded as iOS 26 APIs become available
        }
    }
}

