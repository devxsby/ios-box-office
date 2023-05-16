//
//  MovieDetailRowView.swift
//  BoxOffice
//
//  Created by devxsby on 2023/05/15.
//

import UIKit

enum DetailRowType: String, CaseIterable {
    case directors = "감독"
    case productionYear = "제작년도"
    case openingDate = "개봉일"
    case showTime = "상영시간"
    case watchGrade = "관람등급"
    case nation = "제작국가"
    case genres = "장르"
    case actors = "배우"
}

final class MovieDetailRowView: UIView {
    
    // MARK: - Properties
    
    private let type: DetailRowType
    
    // MARK: - UI Components
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .black
        label.font = .systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initialization
    
    init(with type: DetailRowType) {
        self.type = type
        super.init(frame: .zero)
        setupUI(with: type)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI & Layout

extension MovieDetailRowView {
    
    private func setupUI(with type: DetailRowType) {
        
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            titleLabel.widthAnchor.constraint(equalToConstant: 100)
        ])
        
        NSLayoutConstraint.activate([
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: -10),
            subtitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            subtitleLabel.topAnchor.constraint(equalTo: topAnchor),
            subtitleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            subtitleLabel.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor)
        ])
        
        titleLabel.text = type.rawValue
    }
}

// MARK: - Methods

extension MovieDetailRowView {
    
    func setupData(with info: MovieDetailController.Info) {
        let text: String
        
        switch type {
        case .directors: text = info.directors
        case .productionYear: text = info.productionYear
        case .openingDate: text = info.openingDate
        case .showTime: text = info.showTime
        case .watchGrade: text = info.watchGrade
        case .nation: text = info.nation
        case .genres: text = info.genres
        case .actors: text = info.actors
        }
        
        configureSubtitleLabel(with: text)
    }
    
    private func configureSubtitleLabel(with text: String) {
        isHidden = text.isEmpty
        subtitleLabel.text = text
    }
}
