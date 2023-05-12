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

// MARK: - Domain 레이어의 Entity로 변환 로직

extension BoxOfficeResult {
    func toDomain() -> [BoxOfficeEntity] {
        return dailyBoxOfficeList.map { $0.toDomain() }
    }
}
