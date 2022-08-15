//
//  MovieCellViewModel.swift
//  GluUpMovyDB
//
//  Created by Denis on 11.08.2022.
//

import UIKit

class MovieCellViewModel {
    
    // MARK: - Properties
    
    var title: String {
        return movieEntry.title
    }
    
    private let movieEntry: MovieListResponseEntry
    
    // MARK: - Initializers
    
    init(movieEntry: MovieListResponseEntry) {
        self.movieEntry = movieEntry
    }
    
    // MARK: - Public methods
    
    func getPosterImage(completion: @escaping (UIImage?) -> ()) {
        ImageLoader.shared.getImage(from: movieEntry.posterPath, completion: completion)
    }
}
