//
//  ApiControl+Todos.swift
//  LiveScore_Navigation
//
//  Created by psynet on 7/30/24.
//

import Foundation
import Moya

extension ApiClient {
    
    func getTodoAllList() async throws -> [TodosData] {
        let target: ApisTodos = .getAllList
        let provider = MoyaProvider<ApisTodos>()
        
        return try await withCheckedThrowingContinuation { continuation in
            provider.request(target) { result in
                switch result {
                case .success(let response):
                    do {
                        if let apiResponse = Self.safeDecode(ApiResponse<[TodosData]>.self, from: response.data),
                           let data = apiResponse.data {
                            continuation.resume(returning: data)
                        } else {
                            throw ApiError.decodingError("Failed to decode response or no data")
                        }
                    } catch {
                        continuation.resume(throwing: error)
                    }
                case .failure(let error):
                    continuation.resume(throwing: ApiError.networkError(error.localizedDescription))
                }
            }
        }
    }
    
}
