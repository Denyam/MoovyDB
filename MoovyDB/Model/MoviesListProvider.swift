//
//  MoviesListProvider.swift
//  GluUpMovyDB
//
//  Created by Denis on 10.08.2022.
//

import Foundation

class MoviesListProvider {
    
    // MARK: - Properties
    
    let service: MovieDBServiceProtocol
    
    var currentPage = 0
    var pagesCount = 0
    var movies = [MovieListResponseEntry]()
    var moviesDetails = [Int: MovieDetailsResponse]()

    // MARK: - Public

    static func createProvider() -> MoviesListProvider {
        let service = MovieDBService()
        return MoviesListProvider(service: service)
    }

    init(service: MovieDBServiceProtocol) {
        self.service = service
    }
    
    func getMoreMovies(completion: @escaping ([MovieListResponseEntry]) -> ()) {
        let nextPage = currentPage + 1

        guard (nextPage <= pagesCount) || (pagesCount == 0) else {
            completion([])
            return
        }

        service.moviesList(onPage: nextPage) { [weak self] moviesListResponse in
            guard let self = self,
                  let moviesListResponse = moviesListResponse else {
                DispatchQueue.main.async {
                    completion([])
                }
                return
            }
            
            self.pagesCount = moviesListResponse.totalPages
            
            let newMovies = moviesListResponse.results
            self.movies.append(contentsOf: newMovies)
            
            self.currentPage += 1
            
            DispatchQueue.main.async {
                completion(newMovies)
            }
        }
    }
    
    func getDetails(for movieId: Int, completion: @escaping (MovieDetailsResponse?) -> ()) {
        if let details = moviesDetails[movieId] {
            completion(details)
            return
        }
        
        service.movieDetails(for: movieId) { response in
            guard let response = response else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                
                return
            }
            
            DispatchQueue.main.async {
                completion(response)
            }
        }
    }
}
