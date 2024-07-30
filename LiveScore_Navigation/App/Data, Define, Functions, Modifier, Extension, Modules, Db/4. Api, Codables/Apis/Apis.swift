//
//  Apis.swift
//  LiveScore_Navigation
//
//  Created by psynet on 7/30/24.
//

import Foundation
import Moya

enum Apis {
    case mconfig(deviceType: String, serviceType: String)
}

extension Apis: TargetType {
    var baseURL: URL {
        switch self {
        default:
            return URL(string: DefineUrl.Domain.Api)!
        }
    }
    
    var path: String {
        switch self {
        case .mconfig:
            return "api/dummy/01"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .mconfig:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .mconfig(let deviceType, let serviceType):
            var params = defultParams
//            params["deviceType"] = deviceType
//            params["serviceType"] = serviceType
            
            log(params: params)
            
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        default:
            let params = defultParams
            log(params: params)
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        var header = CommonFunction.defaultHeader()
        
        switch self {
            
        default:
            header["Content-Type"] = "application/json"
        }
        
        return header
    }
    
    
    var defultParams: [String : Any] {
        return CommonFunction.defaultParams()
    }
    
    func log(params: [String: Any]) {
        fLog("\n--- API : \(baseURL)/\(path) -----------------------------------------------------------\n\(params)\nheader[\(headers ?? [:])]\n------------------------------------------------------------------------------------------------------------------------------\n")
    }
}

extension Apis {
    var cacheTime:NSInteger {
        var time = 0
        switch self {
        default: time = 15
        }
        
        return time
    }
}



//MARK: - Log On/Off
extension Apis {
    // 모든 로그를 켜거나 끄는 전체 스위치 역할을 함.
    func isAllLogOn() -> Bool {
        return false
    }
    
    // 특정 로그 타입을 개별적으로 제어할 수 있게 해줌.
    func isLogOn() -> [Bool] {
        switch self {
        default: return [true, true]
        }
    }
    
    // API 요청 관련 로그를 출력할지 결정함.
    func isApiLogOn() -> Bool {
        if self.isAllLogOn(), self.isLogOn()[0] {
            return true
        }
        
        return false
    }
    
    // Api 응답 관련 로그를 출력할지 결정함.
    func isResponseLog() -> Bool {
        if self.isAllLogOn(), self.isLogOn()[1] {
            return true
        }
        
        return false
    }
}


//MARK: - Check Token or not
extension Apis {
    func isCheckToken() -> Bool {
        switch self {
        default: return true
        }
    }
}


//MARK: - Caching Time : Seconds
extension Apis {
    func dataCachingTime() -> Int {
        switch self {
        default: return DataCachingTime.None.rawValue
        }
    }
}
