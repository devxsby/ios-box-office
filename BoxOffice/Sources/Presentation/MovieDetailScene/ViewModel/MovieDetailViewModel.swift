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
    
    private let usecase: FetchMovieDetailUsecaseProtocol
        
    @Observable var input: Input?
    private(set) var output = Output()
    let info: BoxOfficeEntity.MovieInfo
    
    // MARK: - Initialization
    
    init(usecase: FetchMovieDetailUsecaseProtocol,
         with info: BoxOfficeEntity.MovieInfo) {
        self.usecase = usecase
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
            }
        }
    }
    
    private func fetchMovieDetail(movieCode: Int) {
        usecase.fetchMovieDetail(of: movieCode) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let movieDetialEntities):
                print(movieDetialEntities)
            case .failure(let error):
                print(error)
            }
        }
    }
}
