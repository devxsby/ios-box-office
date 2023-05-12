//
//  DailyBoxOffice.swift
//  BoxOffice
//
//  Created by Mason Kim on 2023/04/24.
//

import Foundation

struct DailyBoxOffice: Decodable {
    let rank: String
    let rankIntensity: String
    let rankStatus: RankStatus
    let movieCode: String
    let movieName: String
    let dailyAudienceCount: String
    let cumulativeAudience: String
    
    enum CodingKeys: String, CodingKey {
        case rank
        case rankIntensity = "rankInten"
        case rankStatus = "rankOldAndNew"
        case movieCode = "movieCd"
        case movieName = "movieNm"
        case dailyAudienceCount = "audiCnt"
        case cumulativeAudience = "audiAcc"
    }
}

enum RankStatus: String, Decodable {
    case new = "NEW"
    case old = "OLD"
}

// MARK: - Domain 레이어의 Entity로 변환 로직

extension DailyBoxOffice {
    func toDomain() -> BoxOfficeEntity {
        let isNew: Bool = rankStatus == .new ? true : false
        
        return BoxOfficeEntity(movieInfo: BoxOfficeEntity.MovieInfo(code: Int(movieCode) ?? 0, name: movieName),
                               rank: UInt(rank) ?? 0,
                               isNew: isNew,
                               rankIntensity: Int(rankIntensity) ?? 0,
                               dailyAudienceCount: UInt(dailyAudienceCount) ?? 0,
                               cumulativeAudience: UInt(cumulativeAudience) ?? 0
        )
    }
}
