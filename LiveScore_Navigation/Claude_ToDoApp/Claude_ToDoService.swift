//
//  Claude_ToDoService.swift
//  LiveScore_Navigation
//
//  Created by psynet on 7/30/24.
//

import ComposableArchitecture

private enum ApiClientKey: DependencyKey {
    static let liveValue: APIClientProtocol = ApiClient()
}

extension DependencyValues {
    var apiClient: APIClientProtocol {
        get { self[ApiClientKey.self] }
        set { self[ApiClientKey.self] = newValue }
    }
}
