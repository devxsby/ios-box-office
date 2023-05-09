//
//  BoxOfficeEntity.swift
//  BoxOffice
//
//  Created by devxsby on 2023/05/03.
//

import Foundation

struct BoxOfficeEntity {
    let movieInfo: MovieInfo
    let rank: UInt
    let isNew: Bool
    let rankIntensity: Int
    let dailyAudienceCount: UInt
    let cumulativeAudience: UInt
    
    struct MovieInfo {
        let code: Int
        let name: String
    }
}
