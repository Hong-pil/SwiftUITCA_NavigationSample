//
//  AppState.swift
//  LiveScore_Navigation
//
//  Created by kimhongpil on 7/28/24.
//

import Foundation
import Combine

enum NaviPath: CaseIterable {
    case main
    
    static func push(_ screen: Screen) {
        self.main.push(screen)
    }
    static func pop() {
        self.main.pop()
    }
    static func popRoot() {
        self.main.popRoot()
    }
    
    static func popToIndex(_ index: Int) {
        self.main.popToIndex(index)
    }
    
    func push(_ screen: Screen) {
        switch self {
        case .main:
            AppState.shared.mainNavi.append(screen)
        }
    }
    
    func pop() {
        switch self {
        case .main:
            if AppState.shared.mainNavi.count > 0 {
                AppState.shared.mainNavi.removeLast()
            }
        }
    }
    func popRoot() {
        switch self {
        case .main:
            AppState.shared.mainNavi = []
        }
    }
    
    func popToIndex(_ index: Int) {
        switch self {
        case .main:
            if AppState.shared.mainNavi.count > 0 {
                if index > 0 && index < AppState.shared.mainNavi.count {
                    AppState.shared.mainNavi.removeLast(index)
                }
                else {
                    AppState.shared.mainNavi.removeLast()
                }
            }
        }
    }
}

class AppState: ObservableObject {
    static let shared = AppState()
    var cancelBag = Set<AnyCancellable>()
    @Published var mainNavi: [Screen] = []

    @Published var swipeBackActive: Bool = true

    init() {
        binder()
    }

    func binder() {
        
    }
    
}
