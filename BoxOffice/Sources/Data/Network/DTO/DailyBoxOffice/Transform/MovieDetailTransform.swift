//
//  MovieDetailTransform.swift
//  BoxOffice
//
//  Created by Mason Kim on 2023/05/08.
//

import Foundation

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
