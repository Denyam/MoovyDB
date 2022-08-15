//
//  MovieDetailsViewController.swift
//  GluUpMovyDB
//
//  Created by Denis on 11.08.2022.
//

import UIKit

class MovieDetailsViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var releaseDateLabel: UILabel!
    @IBOutlet var durationLabel: UILabel!
    @IBOutlet var activityView: UIView!
    
    // MARK: - Properties
    
    var viewModel: MovieDetailViewModel? {
        didSet {
            NotificationCenter.default.removeObserver(self, name: nil, object: oldValue)
            
            subscribeToNotifications()
            
            if isViewLoaded {
                startLoading()
            }
        }
    }
    
    // MARK: - Overrides

    override func viewDidLoad() {
        super.viewDidLoad()

        startLoading()
    }
    
    // MARK: - Notifications
    
    @objc private func viewModelDidLoadDetails() {
        stopLoading()
        populateUi()
    }
    
    @objc private func viewModelDidFailToLoadDetails() {
        stopLoading()
    }
    
    // MARK: - Private
    
    private func subscribeToNotifications() {
        guard let viewModel = viewModel else {
            return
        }

        NotificationCenter.default.addObserver(self, selector: #selector(viewModelDidLoadDetails), name: .movieDetailViewModelDidGetDetails, object: viewModel)
        NotificationCenter.default.addObserver(self, selector: #selector(viewModelDidFailToLoadDetails), name: .movieDetailViewModelDidFailToGetDetails, object: viewModel)
    }
    
    private func startLoading() {
        guard let viewModel = viewModel else {
            activityView.isHidden = true
            
            return
        }
        
        activityView.isHidden = false
        viewModel.loadDetails()
    }
    
    private func stopLoading() {
        activityView.isHidden = true
    }
    
    private func populateUi() {
        titleLabel.text = viewModel?.title
        releaseDateLabel.text = viewModel?.releaseDate
        durationLabel.text = viewModel?.duration
    }
}
