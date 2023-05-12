//
//  PosterImageRepository.swift
//  BoxOffice
//
//  Created by devxsby on 2023/05/12.
//

import Foundation

// MARK: - Protocols

protocol PosterImageRepositoryProtocol {
    typealias MoviePosterCompletion = (Result<MoviePosterResponse, NetworkError>) -> Void
    
    func fetchMoviePoster(endPoint: MoviePosterEndpoint, completion: @escaping MoviePosterCompletion)
}

// MARK: - BoxOfficeRepository

final class PosterImageRepository: PosterImageRepositoryProtocol {
    
    // MARK: - Properties
    
    private let router: NetworkRouterProtocol
    
    // MARK: - Initialization
    
    init(router: NetworkRouterProtocol) {
        self.router = router
    }
    
    // MARK: - Public Methods
    
    func fetchMoviePoster(endPoint: MoviePosterEndpoint, completion: @escaping MoviePosterCompletion) {
        router.request(endPoint, completion: completion)
    }
}
