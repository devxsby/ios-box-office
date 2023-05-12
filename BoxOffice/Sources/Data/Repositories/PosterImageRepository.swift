//
//  PosterImageRepository.swift
//  BoxOffice
//
//  Created by devxsby on 2023/05/12.
//

import UIKit

// MARK: - Protocols

protocol PosterImageRepositoryProtocol {
    typealias MoviePosterCompletion = (Result<MoviePosterEntity, NetworkError>) -> Void
    
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
        router.request(endPoint) { [weak self] (result: Result<MoviePosterResponse, NetworkError>) in
            guard let self = self else { return }
            switch result {
            case .success(let moviePosterResponse):
                let imageURL = moviePosterResponse.documents.first?.imageURL ?? ""
                
                let imageEndpoint = DefaultEndpoint(urlString: imageURL)
                self.router.request(imageEndpoint) { (result: Result<Data, NetworkError>) in
                    switch result {
                    case .success(let data):
                        guard let image = UIImage(data: data) else {
                            completion(.failure(.invalidData))
                            return
                        }
                        let entity = MoviePosterEntity(movieName: "?????이름 넣어야 함 parameter에서!!", image: image)
                        completion(.success(entity))
                    case .failure(let error):
                        completion(.failure(error))
                        return
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
