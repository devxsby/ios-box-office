//
//  ImageCacheManager.swift
//  BoxOffice
//
//  Created by Mason Kim on 2023/05/09.
//

import UIKit

final class ImageCacheManager {
    
    // MARK: - Properties
    
    static let shared = ImageCacheManager()
    private let cacheManager = NSCache<NSString, UIImage>()
    
    // MARK: - Initialization
    
    private init() {
        cacheManager.countLimit = 100
    }
    
    // MARK: - Public
    
    func get(for key: String) -> UIImage? {
        cacheManager.object(forKey: key as NSString)
    }
    
    // TODO: 이미지 사이즈가 너무 클 시, 압축해서 저장하는 로직 구현
    func store(_ value: UIImage, for key: String) {
        cacheManager.setObject(value, forKey: key as NSString)
    }
    
}
