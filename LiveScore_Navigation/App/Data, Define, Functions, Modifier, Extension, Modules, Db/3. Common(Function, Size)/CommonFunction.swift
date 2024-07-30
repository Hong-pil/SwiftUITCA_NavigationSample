//
//  CommonFunction.swift
//  LiveScore_Navigation
//
//  Created by psynet on 7/30/24.
//

import Foundation
import UIKit

struct CommonFunction {
    static func defaultParams() -> [String: Any] {
        
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        let osVersion = UIDevice.current.systemVersion
        let countryCode = Locale.current.regionCode ?? ""
        
        var params: [String: Any] = [:]
        params[DefineKey.appVersion] = appVersion
        params[DefineKey.device] = "ios"
        params[DefineKey.osVersion] = osVersion
        params[DefineKey.countryCode] = countryCode
        
        return params
    }
    
    static func defaultHeader(acceptLanguage: String = "") -> [String:String] {
        var header: [String:String] = [:]
        
        if UserManager.shared.isLogin && !UserManager.shared.accessToken.isEmpty {
//            fLog("token ---: \(UserManager.shared.accessToken)")
            //header[DefineKey.access_token] = UserManager.shared.accessToken
            header[DefineKey.authorization] = "bearer " + UserManager.shared.accessToken
        }
        
        return header
    }
    
    
    static func getParameters(url:String) -> Dictionary<String, String> {
        var returnDictionary: Dictionary<String, String> = [:]
        
        let components = URLComponents(string: url)
        let parameters = components?.query ?? ""
        if parameters.count > 0, parameters != "" {
            let items = components?.queryItems ?? []
            for item in items {
                returnDictionary[item.name] = item.value ?? ""
            }
        }
        
        return returnDictionary
    }
    
}
