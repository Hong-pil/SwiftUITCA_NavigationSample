//
//  ApiError.swift
//  LiveScore_Navigation
//
//  Created by psynet on 7/30/24.
//

import Foundation

// MARK: - Error Handling

enum ApiError: Error, Equatable {
    case networkError(String)
    case decodingError(String)
    case invalidStatusCode(Int)
    case unknownError(String)
    
    var localizedDescription: String {
        switch self {
        case .networkError(let message):
            return "Network error: \(message)"
        case .decodingError(let message):
            return "Decoding error: \(message)"
        case .invalidStatusCode(let code):
            return "Invalid status code: \(code)"
        case .unknownError(let message):
            return "Unknown error: \(message)"
        }
    }
}
