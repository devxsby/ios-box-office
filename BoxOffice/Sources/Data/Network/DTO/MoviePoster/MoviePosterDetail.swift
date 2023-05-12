//
//  MoviePosterDetail.swift
//  BoxOffice
//
//  Created by devxsby on 2023/05/08.
//

import Foundation

struct MoviePosterDetail: Decodable {
    let imageURL: String
    let height: Int
    let width: Int

    enum CodingKeys: String, CodingKey {
        case imageURL = "image_url"
        case height
        case width
    }
}
