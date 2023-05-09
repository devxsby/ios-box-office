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
                let entity = movieDetailResponse.movieInfoResult.movieInfo.toDomain()
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
                let imageURL = URL(string: moviePoster.documents.first?.imageURL ?? "")!
                
                // TODO: 이미지 캐싱 / 이미지 가져오는 로직도 ImageFetcher(?) 로 빼기...!
                
                let session = URLSession.shared
                let task = session.dataTask(with: URLRequest(url: imageURL)) { (data, _, _) in
                    
                    let image = UIImage(data: data!)!
                    
                    let entity = MoviePosterEntity(movieName: movieName, image: image)
                    completion(.success(entity))
                }
                task.resume()

            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
