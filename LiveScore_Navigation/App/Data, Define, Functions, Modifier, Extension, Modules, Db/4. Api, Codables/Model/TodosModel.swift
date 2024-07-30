//
//  TodosModel.swift
//  LiveScore_Navigation
//
//  Created by psynet on 7/30/24.
//

import Foundation

struct TodosData: Codable, Equatable, Hashable {
    var idx: Int?
    var title: String?
    var isCompleted: Int?
    
    enum CodingKeys: String, CodingKey {
        case idx, title, isCompleted
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        idx = try container.decodeIfPresent(Int.self, forKey: .idx)
        title = try container.decodeIfPresent(String.self, forKey: .title)
        isCompleted = try container.decodeIfPresent(Int.self, forKey: .isCompleted)
    }
}
