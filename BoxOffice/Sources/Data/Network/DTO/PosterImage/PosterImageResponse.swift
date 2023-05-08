//
//  PosterImageResponse.swift
//  BoxOffice
//
//  Created by devxsby on 2023/05/08.
//

import Foundation

struct PosterImageResponse: Decodable {
    let documents: [PosterImageDetail]
}
