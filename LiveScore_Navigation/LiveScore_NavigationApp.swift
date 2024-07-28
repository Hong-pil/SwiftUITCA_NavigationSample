//
//  LiveScore_NavigationApp.swift
//  LiveScore_Navigation
//
//  Created by kimhongpil on 7/28/24.
//

import SwiftUI
//import ComposableArchitecture

@main
struct LiveScore_NavigationApp: App {
    @StateObject private var appState = AppState_Claude.shared
    
    var body: some Scene {
        WindowGroup {
            //MainNaviView()
            MainNaviView_Claude()
                .environmentObject(appState)
        }
    }
}
