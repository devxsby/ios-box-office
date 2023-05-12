//
//  DIContainer.swift
//  BoxOffice
//
//  Created by devxsby on 2023/05/04.
//

import Foundation

final class DIContainer {
    
    // MARK: - Protocols
    
    static let shared = DIContainer()
    
    private let router: NetworkRouterProtocol
    private let repository: BoxOfficeRepositoryProtocol
    
    // MARK: - Initialization
    
    private init() {
        self.router = NetworkRouter()
        self.repository = BoxOfficeRepository(router: router)
    }
    
    // MARK: - Public Methods
    
    func makeBoxOfficeListController() -> BoxOfficeListController {
//        let usecase = FetchBoxOfficeUsecase(repository: repository)
        let viewModel = BoxOfficeListViewModel(repository: repository)
        let viewController = BoxOfficeListController(viewModel: viewModel)
        return viewController
    }
    
    func makeMovieDetailController(with info: BoxOfficeEntity.MovieInfo) -> MovieDetailController {
//        let usecase = FetchMovieDetailUsecase(repository: repository)
        let viewModel = MovieDetailViewModel(repository: repository, with: info)
        let viewController = MovieDetailController(viewModel: viewModel)
        return viewController
    }
}
