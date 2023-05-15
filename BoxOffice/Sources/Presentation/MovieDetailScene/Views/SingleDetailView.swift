//
//  SingleDetailView.swift
//  BoxOffice
//
//  Created by devxsby on 2023/05/15.
//

import UIKit

final class SingleDetailView: UIView {
    
    // MARK: - UI Components
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
//        label.font = .preferredFont(forTextStyle: .)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var subtitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .black
//        label.font = .preferredFont(forTextStyle: .title3)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI & Layout

extension SingleDetailView {
    
    private func setup() {
        
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            subtitleLabel.centerXAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: -10),
            subtitleLabel.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor)
        ])
    }
}

// MARK: - Methods

extension SingleDetailView {
    
    func setData(title: String, subtitle: String) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
    }
}
