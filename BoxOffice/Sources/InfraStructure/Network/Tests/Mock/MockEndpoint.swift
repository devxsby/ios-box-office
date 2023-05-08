//
//  MockEndpoint.swift
//  BoxOffice
//
//  Created by Mason Kim on 2023/05/02.
//

import Foundation

struct MockEndpoint: EndPointType {
    var baseURL: String = ""
    var path: String = ""
    var httpMethod: HTTPMethod = .get
    var headers: [String: String] = [:]
    var task: HTTPTask = .request    
}
