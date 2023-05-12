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
    let nameEnglish: String
    let nameOriginal: String
    let showTime: String
    let productionYear: String
    let openingDate: String
    let productionStatus: String
    let typeNumber: String
    let nations: [Nation]
    let genres: [Genre]
    let directors: [Director]
    let actors: [Actor]
    let showTypes: [ShowType]
    let companies: [Company]
    let audits: [Audit]
    let staffs: [Staff]

    enum CodingKeys: String, CodingKey {
        case code = "movieCd"
        case name = "movieNm"
        case nameEnglish = "movieNmEn"
        case nameOriginal = "movieNmOg"
        case showTime = "showTm"
        case productionYear = "prdtYear"
        case openingDate = "openDt"
        case productionStatus = "prdtStatNm"
        case typeNumber = "typeNm"
        case nations
        case genres
        case directors
        case actors
        case showTypes
        case companies = "companys"
        case audits
        case staffs
    }
}

// MARK: - Domain 레이어의 Entity로 변환 로직

extension MovieInfo {
    func toDomain() -> MovieDetailEntity {
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
