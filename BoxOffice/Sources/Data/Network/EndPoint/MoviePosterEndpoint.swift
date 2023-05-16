//
//  MoviePosterEndpoint.swift
//  BoxOffice
//
//  Created by Mason Kim on 2023/05/08.
//

import Foundation

enum MoviePosterEndpoint {
    case searchImageFromKakao(movieName: String)
    case searchImageFromGoogle(movieName: String)
}

extension MoviePosterEndpoint: EndPointType {
    
    var baseURL: String {
        switch self {
        case .searchImageFromKakao:
            return "https://dapi.kakao.com/v2/search"
        case .searchImageFromGoogle:
            return "https://www.googleapis.com/customsearch/v1"
        }
        
    }
    
    var path: String {
        switch self {
        case .searchImageFromKakao:
            return "/image"
        case .searchImageFromGoogle:
            return ""
        }
    }
    
    var httpMethod: HTTPMethod {
        return .get
    }
    
    var headers: [String: String] {
        switch self {
        case .searchImageFromKakao:
            return ["Authorization": APIKeys.kakaoSearchSecret]
        case .searchImageFromGoogle:
            return [:]
        }
    }
    
    var task: HTTPTask {
        switch self {
        case let .searchImageFromKakao(movieName: movieName):
            return .requestWithQueryParameters(
                ["query": "\(movieName) 영화 포스터",
                 "size": "1",
                 "sort": "accuracy"]
            )
        case .searchImageFromGoogle(movieName: let movieName):
            return .requestWithQueryParameters(
                ["key": APIKeys.googleSearchSecretKey,
                 "cx": APIKeys.googleSearchSecretCX,
                 "q": "\(movieName) 영화 포스터"]
            )
        }
    }
    
}
