//
//  MovieDBService.swift
//  GluUpMovyDB
//
//  Created by Denis on 09.08.2022.
//

import Foundation

struct MovieDBService: MovieDBServiceProtocol {
    
    // MARK: - Constants
	
	private let rootUrl = "https://api.themoviedb.org/3"
    	
	private let apiKeyValue = "4e24b6c82507130ab750a3ca5996953c"
	private let apiKeyKey = "api_key"
	
	private let moviesListPath = "/discover/movie"
	private let movieDetailsPath = "/movie/"

    private let sortByKey = "sort_by"
    private let sortByPopularityDescValue = "popularity.desc"

    private let pageKey = "page"
    
    // MARK: - MovieDBServiceProtocol

	func moviesList(onPage page: Int, completion: @escaping (MoviesListResponse?) -> ()) {
        let queryDict: [String : Any] = [
            sortByKey: sortByPopularityDescValue,
            pageKey: page
        ]
        
        let url = requestUrl(for: moviesListPath, queryDict: queryDict)
        sendRequest(to: url, completion: completion)
	}
	
	func movieDetails(for movieId: Int, completion: @escaping (MovieDetailsResponse?) -> ()) {
		let url = requestUrl(for: movieDetailsPath, parameter: movieId)
		sendRequest(to: url, completion: completion)
	}
    
    // MARK: - Private

    private func sendRequest<T>(to url: URL?, completion: @escaping (T?) -> ()) where T: Codable {
        guard let url = url else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, _, requestError) in
            guard requestError == nil,
                  let data = data else {
                completion(nil)
                return
            }
            
            do {
                let response = try JSONDecoder().decode(T.self, from: data)
                completion(response)
            } catch {
                print(error)
                completion(nil)
            }
        }.resume()
    }
    
    private func requestUrl(for path: String, parameter: Int? = nil, queryDict: [String: Any] = [:]) -> URL? {
		var urlString = rootUrl + path
		
		if let parameter = parameter {
			urlString += "\(parameter)"
		}
		
        var queryDictWithApiKey = queryDict
		queryDictWithApiKey[apiKeyKey] = apiKeyValue

		var queryString = ""
		for (queryKey, queryValue) in queryDictWithApiKey {
			queryString += "\(queryKey)=\(queryValue)&"
		}
		
		urlString += "?\(queryString)"
		
		let url = URL(string: urlString)
		return url
	}
}
