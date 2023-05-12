//
//  BoxOfficeListViewModel.swift
//  BoxOffice
//
//  Created by devxsby on 2023/05/02.
//

import Foundation

final class BoxOfficeListViewModel: ViewModelType {
    
    // MARK: - Constants
    
    private enum Constants {
        static let dailyAudiencePrefix = "일일"
        static let cumulativeAudiencePrefix = "총"
    }
    
    enum Input {
        case dateChanged(selectedDate: Date)
        case viewDidLoad
        case isRefreshed
    }
    
    struct Output {
        @Observable var cellItems = [BoxOfficeListCell.Item]()
        @Observable var selectedDate = Date().previousDate
    }
    
    // MARK: - Properties
    
    private let repository: BoxOfficeRepositoryProtocol
    
    @Observable var input: Input?
    private(set) var output = Output()
    
    // MARK: - Initialization
    
    init(repository: BoxOfficeRepositoryProtocol) {
        self.repository = repository
        bindInput()
    }
    
    // MARK: - Private Methods
    
    private func bindInput() {
        $input.bind { input in
            guard let input = input else { return }
            switch input {
            case .dateChanged(selectedDate: let date):
                self.output.selectedDate = date
                self.fetchBoxOffice(of: date)
            case .viewDidLoad:
                self.fetchBoxOffice(of: self.output.selectedDate)
            case .isRefreshed:
                self.fetchBoxOffice(of: self.output.selectedDate)
            }
        }
    }
    
    private func fetchBoxOffice(of date: Date) {
        repository.fetchDailyBoxOffice(
            endPoint: .dailyBoxOffice(date: date.formatted("yyyyMMdd"))
        ) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let boxOfficeResponse):
                let boxOfficeListEntity = boxOfficeResponse.boxOfficeResult.toEntity()
                
                let items = boxOfficeListEntity.map {
                    BoxOfficeListCell.Item(
                        code: $0.movieInfo.code,
                        isNew: $0.isNew,
                        name: $0.movieInfo.name,
                        rank: "\($0.rank)",
                        rankIntensity: $0.rankIntensity,
                        audienceCount: self.audienceCountLabelText(with: $0)
                    )
                }
                
                self.output.cellItems = items
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func audienceCountLabelText(with boxOffice: BoxOfficeEntity) -> String {
        guard let formattedDailyAudienceCount = boxOffice.dailyAudienceCount.formatWithCommas(),
              let formattedCumulativeAudience = boxOffice.cumulativeAudience.formatWithCommas() else {
            return ""
        }
        return "\(Constants.dailyAudiencePrefix) \(formattedDailyAudienceCount) / "
        + "\(Constants.cumulativeAudiencePrefix) \(formattedCumulativeAudience)"
    }
}
