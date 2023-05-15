//
//  MovieDetailController.swift
//  BoxOffice
//
//  Created by devxsby on 2023/05/09.
//

import UIKit

final class MovieDetailController: UIViewController {
    
    // MARK: - Properties
    
    private let viewModel: MovieDetailViewModel
    
    // MARK: - UI Components
    
    private let containerScrollView: UIScrollView = {
        let scollView = UIScrollView()
        scollView.showsVerticalScrollIndicator = false
        scollView.translatesAutoresizingMaskIntoConstraints = false
        return scollView
    }()
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let directorView = MovieDetailRowView()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [posterImageView, directorView])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .fill
        stackView.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // MARK: - Initialization
    
    init(viewModel: MovieDetailViewModel) {
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
    }
    
    // MARK: - Private Methods
    
    private func notifyViewDidLoad() {
        viewModel.input = .viewDidLoad
    }
    
    private func bindViewModel() {
        
        viewModel.output.$image.bind { [weak self] image in
            DispatchQueue.main.async {
                self?.posterImageView.image = image
            }
        }
        
    }
    
}

// MARK: - UI & Layout

extension MovieDetailController {
    
    private func setup() {
        setUI()
        setLayout()
    }
    
    private func setUI() {
        setBackgroundColor()
    }
    
    private func setBackgroundColor() {
        view.backgroundColor = .systemBackground
    }
    
    private func setLayout() {
        view.addSubview(containerScrollView)
        
        containerScrollView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            containerScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            containerScrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            containerScrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            containerScrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            posterImageView.heightAnchor.constraint(equalToConstant: 500)
        ])
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: containerScrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: containerScrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: containerScrollView.trailingAnchor),
            stackView.widthAnchor.constraint(equalTo: containerScrollView.widthAnchor, multiplier: 1.0),
            stackView.bottomAnchor.constraint(equalTo: containerScrollView.bottomAnchor)
        ])
        
    }
}

// MARK: - Preview

#if DEBUG
import SwiftUI

struct MovieDetailControllerPreView: PreviewProvider {
    static var previews: some View {
        UINavigationController(
            rootViewController:
                DIContainer.shared.makeMovieDetailController(
                    with: BoxOfficeEntity.MovieInfo(code: 1231231, name: "asdasd")
                )
        )
        .toPreview()
    }
}
#endif
