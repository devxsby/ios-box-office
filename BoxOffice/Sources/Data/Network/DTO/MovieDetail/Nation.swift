//
//  Nation.swift
//  BoxOffice
//
//  Created by devxsby on 2023/05/14.
//

import Foundation

struct Nation: Decodable {
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case name = "nationNm"
    }
}
