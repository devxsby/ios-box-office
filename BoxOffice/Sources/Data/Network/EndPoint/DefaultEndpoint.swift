//
//  DefaultEndpoint.swift
//  BoxOffice
//
//  Created by Mason Kim on 2023/05/12.
//

import Foundation

struct DefaultEndpoint: EndPointType {
  var baseURL: String
  var path: String = ""
  var httpMethod: HTTPMethod = .get
  var headers = [String: String]()
  var task: HTTPTask = .request
  
  init(urlString: String) {
    self.baseURL = urlString
  }
}
