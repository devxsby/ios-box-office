//
//  BoxOfficeListController.swift
//  BoxOffice
//
//  Created by M&A on 13/01/23.
//

import UIKit

final class BoxOfficeListController: UIViewController {
    
    // MARK: - Constants
        
    enum Section: Int, CaseIterable {
        case list
    }
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, BoxOfficeListCell.Item>
    
    // MARK: - Properties
    
    private let viewModel: BoxOfficeListViewModel
    private lazy var dataSource: DataSource = makeDataSource()
    
    // MARK: - UI Components
    
    private lazy var boxOfficeListCollectionView: UICollectionView = {
        let collectionview = UICollectionView(frame: .zero, collectionViewLayout: collectionViewListLayout)
        collectionview.refreshControl = refreshControl
        collectionview.delegate = self
        collectionview.translatesAutoresizingMaskIntoConstraints = false
        return collectionview
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .gray
        refreshControl.addTarget(self, action: #selector(didRefresh), for: .valueChanged)
        return refreshControl
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.center = view.center
        activityIndicator.color = .gray
        activityIndicator.style = .medium
        return activityIndicator
    }()
    
    private lazy var rightButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "날짜선택", style: .plain, target: self, action: #selector(rightBttonPressed))
        return button
    }()
    
    private lazy var calendarViewController: CalendarViewController = {
        let viewController = CalendarViewController()
        viewController.delegate = self
        return viewController
    }()
    
    private let collectionViewListLayout: UICollectionViewLayout = {
        let configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        return UICollectionViewCompositionalLayout.list(using: configuration)
    }()
    
    private let collectionViewGridLayout: UICollectionViewLayout = {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 10, leading: 10, bottom: 10, trailing: 10)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(1.0 / 4))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        return UICollectionViewCompositionalLayout(section: section)
    }()
    
    private let emptyDescriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.textAlignment = .center
        label.font = .preferredFont(forTextStyle: .callout)
        label.text = "영화정보를 받아올 수 없습니다"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initialization
    
    init(viewModel: BoxOfficeListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        bindViewModel()
        notifyViewDidLoad()
        
        changeCollectionViewLayout()
    }
    
    // MARK: - Private Methods
    
    private func notifyViewDidLoad() {
        viewModel.input = .viewDidLoad
    }
    
    private func bindViewModel() {
        
        viewModel.output.$cellItems.bind { [weak self] items in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                if self.refreshControl.isRefreshing {
                    self.refreshControl.endRefreshing()
                }
                self.setAnimatingActivityIndicator(isAnimated: false)
                self.appendSnapshot(with: items)
            }
        }
        
        viewModel.output.$isFailToLoadData.bind(isFireAtBind: false) { [weak self] _ in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.setEmptyView(isEnabled: true)
            }
        }
        
        viewModel.output.$selectedDate.bind { [weak self] date in
            guard let self = self else { return }
            self.title = date.formatted("yyyy-MM-dd")
        }
    }
    
    private func setEmptyView(isEnabled: Bool) {
        boxOfficeListCollectionView.isHidden = isEnabled
        emptyDescriptionLabel.isHidden = !isEnabled
    }
    
    @objc private func didRefresh() {
        viewModel.input = .isRefreshed
    }
    
    @objc private func rightBttonPressed() {
        present(calendarViewController, animated: true)
    }
}

// MARK: - UI & Layout

extension BoxOfficeListController {
    
    private func setup() {
        setUI()
        setLayout()
        setupCollectionView()
    }
    
    private func setUI() {
        setBackgroundColor()
        setAnimatingActivityIndicator(isAnimated: true)
        setNavigationBarItem()
    }
    
    private func setBackgroundColor() {
        view.backgroundColor = .systemBackground
    }
    
    private func setAnimatingActivityIndicator(isAnimated: Bool) {
        guard isAnimated != activityIndicator.isAnimating else { return }
        
        if isAnimated {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
    
    private func setNavigationBarItem() {
        navigationItem.rightBarButtonItem = rightButton
    }
    
    private func setLayout() {
        [emptyDescriptionLabel, boxOfficeListCollectionView, activityIndicator].forEach { view.addSubview($0) }
        
        NSLayoutConstraint.activate([
            boxOfficeListCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            boxOfficeListCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            boxOfficeListCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            boxOfficeListCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            emptyDescriptionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            emptyDescriptionLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            emptyDescriptionLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            emptyDescriptionLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupCollectionView() {
        boxOfficeListCollectionView.registerCell(cellClass: BoxOfficeListCell.self)
        setupInitialSnapshot()
    }
    
    private func createCollectionViewLayout() -> UICollectionViewLayout {
        let configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        return UICollectionViewCompositionalLayout.list(using: configuration)
    }
    
    // TODO: - 레이아웃 변경 테스트용 메서드
    private func changeCollectionViewLayout() {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
            self.boxOfficeListCollectionView.setCollectionViewLayout(self.collectionViewGridLayout, animated: true)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4)) {
            self.boxOfficeListCollectionView.setCollectionViewLayout(self.collectionViewListLayout, animated: true)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(6)) {
            self.boxOfficeListCollectionView.setCollectionViewLayout(self.collectionViewGridLayout, animated: true)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(8)) {
            self.boxOfficeListCollectionView.setCollectionViewLayout(self.collectionViewListLayout, animated: true)
        }
    }
}

// MARK: - DataSource / Snapshot

extension BoxOfficeListController {
    
    private func makeDataSource() -> DataSource {
        UICollectionViewDiffableDataSource(
            collectionView: boxOfficeListCollectionView,
            cellProvider: { collectionView, indexPath, item in
                guard let section = Section(rawValue: indexPath.section) else {
                    return UICollectionViewCell()
                }
                switch section {
                case .list:
                    let cell = collectionView.dequeueReusableCell(cellClass: BoxOfficeListCell.self, for: indexPath)
                    cell.configure(with: item)
                    return cell
                }
            }
        )
    }
    
    private func setupInitialSnapshot() {
        // Section 초기 설정
        var snapshot = dataSource.snapshot()
        snapshot.appendSections(Section.allCases)
        dataSource.apply(snapshot)
    }
    
    private func appendSnapshot(with items: [BoxOfficeListCell.Item]) {
        // list snapshot 설정
        var listSnapshot = NSDiffableDataSourceSectionSnapshot<BoxOfficeListCell.Item>()
        listSnapshot.append(items)
        dataSource.apply(listSnapshot, to: .list)
    }
}

extension BoxOfficeListController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
        let movieInfo = BoxOfficeEntity.MovieInfo(code: item.code, name: item.name)
        let movieDetailVC = DIContainer.shared.makeMovieDetailController(with: movieInfo)
        navigationController?.pushViewController(movieDetailVC, animated: true)
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

// MARK: - CalendarViewControllerDelegate

extension BoxOfficeListController: CalendarViewControllerDelegate {
    func calendarViewController(_ calendarView: CalendarViewController, didSelectDate dateComponents: DateComponents?) {
        guard let date = dateComponents?.date else { return }
        viewModel.input = .dateChanged(selectedDate: date)
    }
}

// MARK: - Preview

#if DEBUG
import SwiftUI

struct BoxOfficeListControllerPreView: PreviewProvider {
    static var previews: some View {
        UINavigationController(rootViewController: DIContainer.shared.makeBoxOfficeListController())
            .toPreview()
    }
}
#endif
