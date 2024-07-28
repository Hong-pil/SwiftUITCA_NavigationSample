//
//  Screen.swift
//  LiveScore_Navigation
//
//  Created by kimhongpil on 7/28/24.
//

import Foundation

//typealias Dest = Destination

enum Screen: Equatable, Identifiable, Hashable {
    case step01(Step01PageReducer.State)
    case step02(Step02PageReducer.State)
    case step03(Step03PageReducer.State)
    
    var id: UUID {
        switch self {
        case .step01(let state):
            return state.id
        case .step02(let state):
            return state.id
        case .step03(let state):
            return state.id
        }
    }
    
    // Hashable 프로토콜 준수를 위한 함수
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
}
