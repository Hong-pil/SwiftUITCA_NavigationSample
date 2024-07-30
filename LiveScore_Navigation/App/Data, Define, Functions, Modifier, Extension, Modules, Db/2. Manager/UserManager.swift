//
//  UserManager.swift
//  LiveScore_Navigation
//
//  Created by psynet on 7/30/24.
//

import Foundation
import SwiftUI
import Combine
import UserNotifications

class UserManager: ObservableObject {
    static let shared = UserManager()
    
    @AppStorage(DefineKey.isFirstLaunching) var isFirstLaunching: Bool = true       //permission, login
    
    
    //MARK: - Variables : State
    @Published var isLogin: Bool = false
  
    //MARK: - Variables : Login
    @AppStorage(DefineKey.accessToken) var accessToken: String = ""
    @AppStorage(DefineKey.refreshToken) var refreshToken: String = ""
    

    var canclelables = Set<AnyCancellable>()
    
}
