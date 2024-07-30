//
//  WordListModel.swift
//  LiveScore_Navigation
//
//  Created by psynet on 7/30/24.
//

import Foundation

struct SVGFilesData: Codable, Equatable {
    var files: [String]?
    var currentPage: Int?
    var totalPages: Int?
    var totalFiles: Int?
    
    enum CodingKeys: String, CodingKey {
        case files, currentPage, totalPages, totalFiles
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        files = try container.decodeIfPresent([String].self, forKey: .files)
        currentPage = try container.decodeIfPresent(Int.self, forKey: .currentPage)
        totalPages = try container.decodeIfPresent(Int.self, forKey: .totalPages)
        totalFiles = try container.decodeIfPresent(Int.self, forKey: .totalFiles)
    }
}
