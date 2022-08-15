//
//  MovieDetailViewModel.swift
//  GluUpMovyDB
//
//  Created by Denis on 11.08.2022.
//

import Foundation

extension Notification.Name {
    static let movieDetailViewModelDidGetDetails = Notification.Name("movieDetailViewModelDidGetDetails")
    static let movieDetailViewModelDidFailToGetDetails = Notification.Name("movieDetailViewModelDidFailToGetDetails")
}

class MovieDetailViewModel {
    
    // MARK: - Properties
    
    var title: String {
        return movieDetails?.title ?? ""
    }
    
    var releaseDate: String {
        return movieDetails?.releaseDate ?? ""
    }
    
    var duration: String {
        guard let runtime = movieDetails?.runtime else {
            return ""
        }
        
        return "\(runtime)"
    }
    
    private let provider: MoviesListProvider
    private let movieId: Int
    
    private var movieDetails: MovieDetailsResponse? {
        didSet {
            NotificationCenter.default.post(name: .movieDetailViewModelDidGetDetails, object: self)
        }
    }
    
    // MARK: - Initializers
    
    init(provider: MoviesListProvider, movieId: Int) {
        self.provider = provider
        self.movieId = movieId
    }
    
    // MARK: - Public methods
    
    func loadDetails() {
        provider.getDetails(for: movieId) { [weak self] response in
            guard let self = self else {
                return
            }
            
            guard let details = response else {
                NotificationCenter.default.post(name: .movieDetailViewModelDidFailToGetDetails, object: self)
                return
            }
            
            self.movieDetails = details
        }
    }
}
