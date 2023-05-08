//
//  EndPointType.swift
//  BoxOffice
//
//  Created by devxsby on 2023/04/27.
//

import Foundation

protocol EndPointType {
    var baseURL: String { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var headers: [String: String] { get }
    var task: HTTPTask { get }
}
