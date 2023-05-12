//
//  MoviePosterEndpoint.swift
//  BoxOffice
//
//  Created by Mason Kim on 2023/05/08.
//

import Foundation

enum MoviePosterEndpoint {
    case fetchImage(movieName: String)
}

extension MoviePosterEndpoint: EndPointType {
    
    var baseURL: String {
        return "https://dapi.kakao.com/v2/search"
    }
    
    var path: String {
        switch self {
        case .fetchImage:
            return "/image"
        }
    }
    
    var httpMethod: HTTPMethod {
        return .get
    }
    
    var headers: [String: String] {
        return ["Authorization": APIKeys.kakaoSearchSecret]
    }
    
    var task: HTTPTask {
        switch self {
        case let .fetchImage(movieName: movieName):
            return .requestWithQueryParameters(
                ["query": "\(movieName) 영화 포스터",
                 "size": "1",
                 "sort": "accuracy"]
            )
        }
    }
    
}
