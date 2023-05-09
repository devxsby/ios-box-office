//
//  FetchMovieDetailUsecase.swift
//  BoxOffice
//
//  Created by Mason Kim on 2023/05/08.
//

import Foundation

// MARK: - Protocols

protocol FetchMovieDetailUsecaseProtocol {
    typealias FetchMovieDetailCompletion = (Result<MovieDetailEntity, Error>) -> Void
    typealias FetchMoviePosterCompletion = (Result<MoviePosterEntity, Error>) -> Void
    
    func fetchMovieDetail(of movieCode: Int, completion: @escaping FetchMovieDetailCompletion)
    func fetchMoviePoster(of movieName: String, completion: @escaping FetchMovieDetailCompletion)
}

// MARK: - FetchMovieDetailUsecase

final class FetchMovieDetailUsecase: FetchMovieDetailUsecaseProtocol {
    
    // MARK: - Properties
    
    private let repository: BoxOfficeRepositoryProtocol
    
    // MARK: - Initialization
    
    init(repository: BoxOfficeRepositoryProtocol) {
        self.repository = repository
    }
    
    // MARK: - Public Methods
    func fetchMovieDetail(of movieCode: Int, completion: @escaping FetchMovieDetailCompletion) {
        repository.fetchMovieDetail(endPoint: .movieDetail(movieCode: movieCode)) { result in
            switch result {
            case .success(let movieDetailResponse):
                let entity = movieDetailResponse.movieInfoResult.movieInfo.toDomain()
                completion(.success(entity))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchMoviePoster(of movieName: String, completion: @escaping FetchMovieDetailCompletion) {
        
    }
}
