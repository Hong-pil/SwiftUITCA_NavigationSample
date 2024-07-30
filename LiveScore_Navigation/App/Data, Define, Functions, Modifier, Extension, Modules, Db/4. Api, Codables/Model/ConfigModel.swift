//
//  ConfigModel.swift
//  LiveScore_Navigation
//
//  Created by psynet on 7/30/24.
//

import Foundation

struct MconfigData: Codable, Equatable {
    var adUrl: String?
    var apiUrl: String?
    var currentVersion: String?
    var description: String?
    var deviceType: String?
    var enable: Int?
    var endDate: String?
    var forceUpdate: Int?
    var imageUrl: String?
    var integUid: String?
    var messageEng: String?
    var messageKr: String?
    var payUrl: String?
    var startDate: String?
    var transUrl: String?
    var updateEnable: Int?
    var webUrl: String?
    var popupAppLink: String?
    var popupImgKo: String?
    var popupImgEn: String?
    var popupStartDate: String?
    var popupEndDate: String?
    var popupEnable: Int?
    
    enum CodingKeys: String, CodingKey {
        case adUrl, apiUrl, currentVersion, description, deviceType, enable, endDate, forceUpdate, imageUrl, integUid, messageEng, messageKr, payUrl, startDate, transUrl, updateEnable, webUrl, popupAppLink, popupImgKo, popupImgEn, popupStartDate, popupEndDate, popupEnable
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        adUrl = try container.decodeIfPresent(String.self, forKey: .adUrl)
        apiUrl = try container.decodeIfPresent(String.self, forKey: .apiUrl)
        currentVersion = try container.decodeIfPresent(String.self, forKey: .currentVersion)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        deviceType = try container.decodeIfPresent(String.self, forKey: .deviceType)
        enable = try container.decodeIfPresent(Int.self, forKey: .enable)
        endDate = try container.decodeIfPresent(String.self, forKey: .endDate)
        forceUpdate = try container.decodeIfPresent(Int.self, forKey: .forceUpdate)
        imageUrl = try container.decodeIfPresent(String.self, forKey: .imageUrl)
        integUid = try container.decodeIfPresent(String.self, forKey: .integUid)
        messageEng = try container.decodeIfPresent(String.self, forKey: .messageEng)
        messageKr = try container.decodeIfPresent(String.self, forKey: .messageKr)
        payUrl = try container.decodeIfPresent(String.self, forKey: .payUrl)
        startDate = try container.decodeIfPresent(String.self, forKey: .startDate)
        transUrl = try container.decodeIfPresent(String.self, forKey: .transUrl)
        updateEnable = try container.decodeIfPresent(Int.self, forKey: .updateEnable)
        webUrl = try container.decodeIfPresent(String.self, forKey: .webUrl)
        popupAppLink = try container.decodeIfPresent(String.self, forKey: .popupAppLink)
        popupImgKo = try container.decodeIfPresent(String.self, forKey: .popupImgKo)
        popupImgEn = try container.decodeIfPresent(String.self, forKey: .popupImgEn)
        popupStartDate = try container.decodeIfPresent(String.self, forKey: .popupStartDate)
        popupEndDate = try container.decodeIfPresent(String.self, forKey: .popupEndDate)
        popupEnable = try container.decodeIfPresent(Int.self, forKey: .popupEnable)
    }
}
