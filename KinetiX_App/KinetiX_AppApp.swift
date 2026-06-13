//
//  KinetiX_AppApp.swift
//  KinetiX_App
//
//  Created by Ayush Ahuja on 02/05/26.
//

import SwiftUI

@main
struct KinetiX_AppApp: App {
    @State private var isSplashActive = true

    var body: some Scene {
        WindowGroup {
            if isSplashActive {
                SplashView(isActive: $isSplashActive)
            } else {
                ContentView()
            }
        }
    }
}
