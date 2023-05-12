//
//  FetchMovieDetailUsecase.swift
//  BoxOffice
//
//  Created by Mason Kim on 2023/05/08.
//

import Foundation
import UIKit

// MARK: - Protocols

protocol FetchMovieDetailUsecaseProtocol {
    typealias FetchMovieDetailCompletion = (Result<MovieDetailEntity, Error>) -> Void
    typealias FetchMoviePosterCompletion = (Result<MoviePosterEntity, Error>) -> Void
    
    func fetchMovieDetail(of movieCode: Int, completion: @escaping FetchMovieDetailCompletion)
    func fetchMoviePoster(of movieName: String, completion: @escaping FetchMoviePosterCompletion)
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
                let entity = movieDetailResponse.movieInfoResult.movieInfo.toEntity()
                completion(.success(entity))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchMoviePoster(of movieName: String, completion: @escaping FetchMoviePosterCompletion) {
        
        repository.fetchMoviePoster(endPoint: .fetchImage(movieName: movieName)) { result in
            switch result {
            case .success(let moviePoster):
                let urlString = moviePoster.documents.first?.imageURL ?? ""
                
                ImageManager.fetchImage(from: urlString) { result in
                    switch result {
                    case .success(let image):
                        let entity = MoviePosterEntity(movieName: movieName, image: image)
                        completion(.success(entity))
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
