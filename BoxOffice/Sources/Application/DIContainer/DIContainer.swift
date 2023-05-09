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
    
//    private let router: NetworkRouterProtocol
//
//    private let repository: BoxOfficeRepositoryProtocol
    
    // MARK: - Initialization
    
    private init() { }
    
    // MARK: - Public Methods
    
    func makeBoxOfficeListController() -> BoxOfficeListController {
        let router = NetworkRouter()
        let repository = BoxOfficeRepository(router: router)
        let usecase = FetchBoxOfficeUsecase(repository: repository)
        let viewModel = BoxOfficeListViewModel(usecase: usecase)
        let viewController = BoxOfficeListController(viewModel: viewModel)
        return viewController
    }
    
    func makeMovieDetailController() -> MovieDetailController {
        let router = NetworkRouter()
        let repository = BoxOfficeRepository(router: router)
        let usecase = FetchMovieDetailUsecase(repository: repository)
        let viewModel = MovieDetailViewModel(usecase: usecase)
        let viewController = MovieDetailController(viewModel: viewModel)
        return viewController
    }
}
