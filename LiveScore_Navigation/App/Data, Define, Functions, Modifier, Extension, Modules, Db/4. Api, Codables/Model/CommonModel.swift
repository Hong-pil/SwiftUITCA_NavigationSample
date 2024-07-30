//
//  CommonModel.swift
//  LiveScore_Navigation
//
//  Created by psynet on 7/30/24.
//

import Foundation

struct ApiResponse<T: Codable>: Codable {
    let code: Int
    let success: Bool
    let message: String
    let timestamp: String
    let data: T?
    
    enum CodingKeys: String, CodingKey {
        case code, success, message, timestamp, data
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        code = try container.decodeIfPresent(Int.self, forKey: .code) ?? 0
        success = try container.decodeIfPresent(Bool.self, forKey: .success) ?? false
        message = try container.decodeIfPresent(String.self, forKey: .message) ?? ""
        timestamp = try container.decodeIfPresent(String.self, forKey: .timestamp) ?? ""
        data = try? container.decodeIfPresent(T.self, forKey: .data)
    }
}

struct ErrorModel: Codable, Equatable, Error {
    var code: String = ""
    var msg: String? = ""
    var dataObj: DataObj? = nil

    var message: String {
        return "에러 발생해뜸 u,u"
    }
    
    var accessToken: String {
        return dataObj?.access_token ?? ""
    }
    
    var needReLogin: Bool {
        return accessToken.isEmpty
    }
}

struct DataObj: Codable, Equatable {
    var access_token: String? = nil
    var path: String? = nil
    var error: String? = nil
    var time: String? = nil
    var message: String? = nil
}

struct ResultModel: Codable {
    let success: Bool
}
