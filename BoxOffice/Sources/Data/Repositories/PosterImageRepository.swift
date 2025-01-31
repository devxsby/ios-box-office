//
//  PosterImageRepository.swift
//  BoxOffice
//
//  Created by devxsby on 2023/05/12.
//

import UIKit

// MARK: - Protocols

protocol PosterImageRepositoryProtocol {
    typealias MoviePosterCompletion = (Result<UIImage, NetworkError>) -> Void
    
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
        router.request(with: endPoint) { [weak self] (result: Result<MoviePosterResponse, NetworkError>) in
            guard let self = self else { return }
            switch result {
            case .success(let moviePosterResponse):
                let imageURL = moviePosterResponse.documents.first?.imageURL ?? ""
                router.request(with: imageURL) { result in
                    switch result {
                    case .success(let data):
                        guard let image = UIImage(data: data) else {
                            completion(.failure(.parseError))
                            return
                        }
                        completion(.success(image))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
