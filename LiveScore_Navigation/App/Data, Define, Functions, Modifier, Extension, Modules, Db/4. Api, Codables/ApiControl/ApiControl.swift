//
//  ApiControl.swift
//  LiveScore_Navigation
//
//  Created by psynet on 7/30/24.
//

import Foundation
import Moya


// API 클라이언트를 의존성으로 정의
// MARK: - API Client Protocol
protocol APIClientProtocol {
    func mconfig(deviceType: String, serviceType: String) async throws -> MconfigData
    func svgFiles(page: Int) async throws -> SVGFilesData
    func getTodoAllList() async throws -> [TodosData]
}

// MARK: - API Client Implementation
struct ApiClient: APIClientProtocol {
    
    func mconfig(deviceType: String, serviceType: String) async throws -> MconfigData {
        let target: Apis = .mconfig(deviceType: deviceType, serviceType: serviceType)
        let provider = MoyaProvider<Apis>()
        
        return try await withCheckedThrowingContinuation { continuation in
            provider.request(target) { result in
                switch result {
                case .success(let response):
                    do {
                        if let apiResponse = Self.safeDecode(ApiResponse<MconfigData>.self, from: response.data),
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
    
    static func safeDecode<T: Decodable>(_ type: T.Type, from data: Data) -> T? {
        do {
            return try JSONDecoder().decode(type, from: data)
        } catch {
            print("Decoding error: \(error)")
            return nil
        }
    }
}
