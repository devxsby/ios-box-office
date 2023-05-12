//
//  MovieInfo.swift
//  BoxOffice
//
//  Created by devxsby on 2023/04/28.
//

import Foundation

struct MovieInfo: Decodable {
    let code: String
    let name: String
    let showTime: String
    let productionYear: String
    let openingDate: String
    let genres: [Genre]
    let directors: [Director]
    let actors: [Actor]
    let audits: [Audit]

    enum CodingKeys: String, CodingKey {
        case code = "movieCd"
        case name = "movieNm"
        case showTime = "showTm"
        case productionYear = "prdtYear"
        case openingDate = "openDt"
        case genres
        case directors
        case actors
        case audits
    }
}

// MARK: - Domain 레이어의 Entity로 변환 로직

extension MovieInfo {
    func toEntity() -> MovieDetailEntity {
        return MovieDetailEntity(name: name,
                                 directors: directors.map { $0.name },
                                 productionYear: Int(productionYear) ?? 0,
                                 openingDate: openingDate.convertToDate() ?? Date(),
                                 showTime: Int(showTime) ?? 0,
                                 watchGrade: audits.first?.watchGrade ?? "",
                                 genres: genres.map { $0.name },
                                 actors: actors.map { $0.name })
    }
}

// MARK: - Date 변환 로직 ("20230101" -> Date)

private extension String {
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        return formatter
    }()
    
    func convertToDate() -> Date? {
        Self.dateFormatter.date(from: self)
    }
}
