//
//  BoxOfficeListController.swift
//  BoxOffice
//
//  Created by M&A on 13/01/23.
//

import UIKit

final class BoxOfficeListController: UIViewController {
    
    // MARK: - Constants
    
    enum Metric {}
    
    // MARK: - Section, DataSource
    
    enum Section: Int, CaseIterable {
        case list
    }
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, DailyBoxOffice>
    
    // MARK: - Properties
    
    private let dailyBoxOfficeList: [DailyBoxOffice]! = {
        let data = MockData.boxOffice
        let decodedData = try? JSONDecoder().decode(DailyBoxOfficeResponse.self, from: data!)
        return decodedData?.boxOfficeResult.dailyBoxOfficeList
    }()
    
    private var dataSource: DataSource?
    
    // MARK: - UI Components
    
    private lazy var boxOfficeListCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: createCollectionViewLayout()
    )
    
    // MARK: - Initialization
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    // MARK: - Public Methods
    
    // MARK: - Private Methods
    
}

// MARK: - UI & Layout

extension BoxOfficeListController {
    
    private func setup() {
        setUI()
        setLayout()
        setupCollectionView()
    }
    
    private func setUI() {
        setCurrentDateTitle()
    }
    
    private func setLayout() {
        view.addSubview(boxOfficeListCollectionView)
        boxOfficeListCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            boxOfficeListCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            boxOfficeListCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            boxOfficeListCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            boxOfficeListCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupCollectionView() {
        boxOfficeListCollectionView.registerCell(cellClass: BoxOfficeListCell.self)
        setupCollectionViewDataSource()
        setupInitialSnapshot()
    }
    
    private func createCollectionViewLayout() -> UICollectionViewLayout {
        let configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        return UICollectionViewCompositionalLayout.list(using: configuration)
    }
    
    private func setCurrentDateTitle() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let formattedDate = dateFormatter.string(from: Date())
        title = formattedDate
    }
}

// MARK: UICollectionViewDataSource

extension BoxOfficeListController {
    private func setupCollectionViewDataSource() {
        dataSource = UICollectionViewDiffableDataSource(
            collectionView: boxOfficeListCollectionView,
            cellProvider: { collectionView, indexPath, dailyBoxOffice in
                guard let section = Section(rawValue: indexPath.section) else {
                    return UICollectionViewCell()
                }
                
                switch section {
                case .list:
                    let cell = collectionView.dequeueReusableCell(cellClass: BoxOfficeListCell.self, for: indexPath)
                    cell.configure(with: dailyBoxOffice)
                    return cell
                }
            }
        )
    }
    
    private func setupInitialSnapshot() {
        guard let dataSource = dataSource else { return }
        
        // Section 초기 설정
        var snapshot = dataSource.snapshot()
        snapshot.appendSections(Section.allCases)
        dataSource.apply(snapshot)
        
        // list snapshot 설정
        var listSnapshot = NSDiffableDataSourceSectionSnapshot<DailyBoxOffice>()
        listSnapshot.append(dailyBoxOfficeList)
        dataSource.apply(listSnapshot, to: .list)
        
        // 또는, 이런 방식도 가능함
//        var listSnapshot = dataSource.snapshot()
//        listSnapshot.appendItems(dailyBoxOfficeList, toSection: .list)
//        dataSource.apply(listSnapshot)
    }
}
