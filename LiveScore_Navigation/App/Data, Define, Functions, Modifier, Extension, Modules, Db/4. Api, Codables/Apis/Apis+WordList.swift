//
//  Apis+WordList.swift
//  LiveScore_Navigation
//
//  Created by psynet on 7/30/24.
//

import Foundation
import Moya

enum ApisWordList {
    case svgFiles(page: Int)
}

extension ApisWordList: TargetType {
    var baseURL: URL {
        switch self {
        default:
            return URL(string: DefineUrl.Domain.Api)!
        }
    }
    
    var path: String {
        switch self {
        case .svgFiles:
            return "/api/svg-files"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .svgFiles:
            return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .svgFiles(let page):
            var params = defultParams
            params["page"] = page
            
            log(params: params)
            
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        }
    }
    
    var headers: [String: String]? {
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

//MARK: - Log On/Off
extension ApisWordList {
    func isAlLogOn() -> Bool {
        return true
    }
    
    func isLogOn() -> [Bool] {
        switch self {
        default: return [true, true]
        }
    }
    
    func isApiLogOn() -> Bool {
        if self.isAlLogOn(), self.isLogOn()[0] {
            return true
        }
        return false
    }
    
    func isResponseLog() -> Bool {
        if self.isAlLogOn(), self.isLogOn()[1] {
            return true
        }
        return false
    }
}

//MARK: - Check Token or not
extension ApisWordList {
    func isCheckToken() -> Bool {
        switch self {
        default: return true
        }
    }
}

//MARK: - Caching Time : Seconds
extension ApisWordList {
    func dataCachingTime() -> Int {
        switch self {
        default: return DataCachingTime.None.rawValue
        }
    }
}
