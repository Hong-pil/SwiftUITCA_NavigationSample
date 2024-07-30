//
//  Define.swift
//  LiveScore_Navigation
//
//  Created by psynet on 7/30/24.
//

import Foundation

public func fLog(_ object: Any, filename: String = #fileID, _ line: Int = #line, _ funcname: String = #function, _ date: Date = Date()) {
    print("[\(date)][\(filename) \(line)] \(object)")
}

// Codable을 준수하는 어떤 타입의 데이터도 받아 JSON 형태로 예쁘게 출력하는 함수
func printPrettyJSON<T: Codable>(keyWord: String, from codableData: T) {
    // JSONEncoder를 사용하여 struct 배열을 JSON 문자열로 변환
    let encoder = JSONEncoder()
    encoder.outputFormatting = .prettyPrinted // 예쁘게 출력하기 위한 설정
    
    do {
        let jsonData = try encoder.encode(codableData)
        if let jsonString = String(data: jsonData, encoding: .utf8) {
            print("\(keyWord)\(jsonString)")
        }
    } catch {
        print("Error encoding JSON: \(error)")
    }
}
