//
//  MovieDetailController.swift
//  BoxOffice
//
//  Created by devxsby on 2023/05/09.
//

import UIKit

final class MovieDetailController: UIViewController {
    
    // MARK: - Properties
    
    let viewModel: MovieDetailViewModel
    var movieCode: Int!
    
    // MARK: - UI Components
    
    private let sampleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        bindViewModel()
        setup()
    }
    
    // MARK: - Private Methods
    
    private func bindViewModel() {
        viewModel.input = .viewDidLoad
        viewModel.movieCode = movieCode
        sampleLabel.text = String(movieCode)
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
        view.addSubview(sampleLabel)
        
        NSLayoutConstraint.activate([
            sampleLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            sampleLabel.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
    }
}

// MARK: - Preview

#if DEBUG
import SwiftUI

struct MovieDetailControllerPreView: PreviewProvider {
    static var previews: some View {
        UINavigationController(rootViewController: DIContainer.shared.makeMovieDetailController())
            .toPreview()
    }
}
#endif
