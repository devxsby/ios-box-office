//
//  MovieDetailViewModel.swift
//  BoxOffice
//
//  Created by devxsby on 2023/05/09.
//

import UIKit

final class MovieDetailViewModel: ViewModelType {
    
    // MARK: - Constants
    
    enum Constants {
        
    }
    
    enum Input {
        case viewDidLoad
    }
    
    struct Output {
        @Observable var image = UIImage()
        
        // 이거도 한번 더 감쌀지?
        @Observable var directors = String()
        var productionYear = String()
        var openingDate = String()
        var showTime = String()
        var watchGrade = String()
        var nation = String()
        var genres = String()
        var actors = String()
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
                self.fetchMovieDetail(movieCode: self.info.code)
                self.fetchMoviePosterImage()
            }
        }
    }
    
    private func fetchMovieDetail(movieCode: Int) {
        boxOfficeRepository.fetchMovieDetail(endPoint: .movieDetail(movieCode: movieCode)) { result in
            switch result {
            case .success(let movieDetailResponse):
                let entity = movieDetailResponse.movieInfoResult.movieInfo.toEntity()
                
                let output = Output(directors: entity.directors.joined(separator: ", "),
                                    productionYear: String(entity.productionYear),
                                    openingDate: entity.openingDate.formatted("yyyy"),
                                    showTime: String(entity.showTime),
                                    watchGrade: entity.watchGrade,
                                    nation: entity.nations.joined(separator: ", "),
                                    genres: entity.genres.joined(separator: ", "),
                                    actors: entity.actors.joined(separator: ", ")
                )
                self.output = output
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func fetchMoviePosterImage() {
        imageRepository.fetchMoviePoster(endPoint: .fetchImage(movieName: info.name)) { result in
            switch result {
            case .success(let image):
                self.output.image = image
            case .failure(let error):
                print(error)
            }
        }
    }
}
