//
//  MoviesListResponse.swift
//  GluUpMovyDB
//
//  Created by Denis on 10.08.2022.
//

import Foundation

struct MoviesListResponse: Codable {
    let page: Int
    let totalPages: Int
    let results: [MovieListResponseEntry]
    
    enum CodingKeys: String, CodingKey {
        case page = "page"
        case results = "results"
        case totalPages = "total_pages"
    }
}
