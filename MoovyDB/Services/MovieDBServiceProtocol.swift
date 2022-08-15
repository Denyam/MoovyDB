//
//  MovieDBServiceProtocol.swift
//  GluUpMovyDB
//
//  Created by Denis on 09.08.2022.
//

import Foundation

protocol MovieDBServiceProtocol {
    func moviesList(onPage page: Int, completion: @escaping (MoviesListResponse?) -> ())
	func movieDetails(for movieId: Int, completion: @escaping (MovieDetailsResponse?) -> ())
}
