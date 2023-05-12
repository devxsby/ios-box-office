//
//  MovieDetailViewModel.swift
//  BoxOffice
//
//  Created by devxsby on 2023/05/09.
//

import Foundation

final class MovieDetailViewModel: ViewModelType {
    
    // MARK: - Constants
    
    enum Constants {
        
    }
    
    enum Input {
        case viewDidLoad
    }
    
    struct Output {
        
    }
    
    // MARK: - Properties
    
    private let boxOfficeRepository: BoxOfficeRepositoryProtocol
    private let imageRepository: PosterImageRepositoryProtocol

    @Observable var input: Input?
    private(set) var output = Output()
    
    private let info: BoxOfficeEntity.MovieInfo
    
    // MARK: - Initialization
    
    init(repository: BoxOfficeRepositoryProtocol,
         imageRepository: PosterImageRepositoryProtocol,
         with info: BoxOfficeEntity.MovieInfo) {
        self.boxOfficeRepository = repository
        self.imageRepository = imageRepository
        self.info = info
        
        bindInput()
    }
    
    // MARK: - Private Methods
    
    private func bindInput() {
        $input.bind(isFireAtBind: false) { [weak self] input in
            guard let input = input,
                  let self = self else { return }
            switch input {
            case .viewDidLoad:
                self.fetchMovieDetail(movieCode: self.info.code) // TODO: - movie code 들어가는 로직 확인하기
                self.fetchMoviePosterImage()
            }
        }
    }
    
    private func fetchMovieDetail(movieCode: Int) {
        boxOfficeRepository.fetchMovieDetail(endPoint: .movieDetail(movieCode: movieCode)) { result in
            switch result {
            case .success(let movieDetailResponse):
                let entity = movieDetailResponse.movieInfoResult.movieInfo.toEntity()
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func fetchMoviePosterImage() {
        imageRepository.fetchMoviePoster(endPoint: .fetchImage(movieName: info.name)) { result in
            switch result {
            case .success(let entity):
                print(entity.image)
            case .failure(let error):
                print(error)
            }
        }
    }
}
