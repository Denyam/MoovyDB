//
//  MoviesListViewModel.swift
//  GluUpMovyDB
//
//  Created by Denis on 11.08.2022.
//

import UIKit

// MARK: - Notification names

extension Notification.Name {
    static let moviesListViewModelDidLoadPage = Notification.Name("moviesListViewModelDidLoadPage")
}

class MoviesListViewModel {
        
    // MARK: - Properties
    
    var provider: MoviesListProvider
    
    var moviesCount: Int {
        return provider.movies.count
    }
    
    // MARK: - Initialisers
    
    init(provider: MoviesListProvider) {
        self.provider = provider
    }
    
    // MARK: - Public methods
    
    func loadPage() {
        provider.getMoreMovies { _ in
            NotificationCenter.default.post(name: .moviesListViewModelDidLoadPage, object: self)
        }
    }
    
    func cellViewModel(at indexPath: IndexPath) -> MovieCellViewModel? {
        let index = indexPath.row
        
        guard index < provider.movies.count else {
            return nil
        }
        
        return MovieCellViewModel(movieEntry: provider.movies[index])
    }
    
    func detailViewModel(at indexPath: IndexPath) -> MovieDetailViewModel? {
        let index = indexPath.row
        
        guard index < provider.movies.count else {
            return nil
        }

        let movieId = provider.movies[index].id
        return MovieDetailViewModel(provider: provider, movieId: movieId)
    }
}
