//
//  BoxOfficeResult.swift
//  BoxOffice
//
//  Created by Mason Kim on 2023/04/24.
//

import Foundation

struct BoxOfficeResult: Decodable {
    let dailyBoxOfficeList: [DailyBoxOffice]
    
    enum CodingKeys: String, CodingKey {
        case dailyBoxOfficeList
    }
}

// MARK: - Entity로 변환 로직

extension BoxOfficeResult {
    func toEntity() -> [BoxOfficeEntity] {
        return dailyBoxOfficeList.map { $0.toEntity() }
    }
}
