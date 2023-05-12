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
    private let boxOfficeRepository: BoxOfficeRepositoryProtocol
    private let imageRepository: PosterImageRepositoryProtocol
    
    // MARK: - Initialization
    
    private init() {
        self.router = NetworkRouter()
        self.boxOfficeRepository = BoxOfficeRepository(router: router)
        self.imageRepository = PosterImageRepository(router: router)
    }
    
    // MARK: - Public Methods
    
    func makeBoxOfficeListController() -> BoxOfficeListController {
        let viewModel = BoxOfficeListViewModel(repository: boxOfficeRepository)
        let viewController = BoxOfficeListController(viewModel: viewModel)
        return viewController
    }
    
    func makeMovieDetailController(with info: BoxOfficeEntity.MovieInfo) -> MovieDetailController {
        let viewModel = MovieDetailViewModel(repository: boxOfficeRepository,
                                             imageRepository: imageRepository,
                                             with: info)
        let viewController = MovieDetailController(viewModel: viewModel)
        return viewController
    }
}
