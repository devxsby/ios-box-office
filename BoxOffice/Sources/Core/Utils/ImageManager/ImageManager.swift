//
//  ImageManager.swift
//  BoxOffice
//
//  Created by Mason Kim on 2023/05/09.
//

import UIKit

enum ImageManager {
    
    typealias ImageManagerCompletion = (Result<UIImage, NetworkError>) -> Void
    
    static func fetchImage(from urlString: String, completion: @escaping ImageManagerCompletion) {
        if let image = ImageCacheManager.shared.get(for: urlString) {
            completion(.success(image))
            return
        }
        
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }
        let urlRequest = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            
            if let error = error {
                completion(.failure(.transportError(error)))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse,
               !(200..<300).contains(httpResponse.statusCode) {
                completion(.failure(.responseError(statusCode: httpResponse.statusCode)))
                return
            }
            
            guard let data = data,
                  let image = UIImage(data: data) else {
                completion(.failure(.invalidData))
                return
            }
            
            completion(.success(image))
            ImageCacheManager.shared.store(image, for: urlString)
        }
        
        task.resume()
    }
}
