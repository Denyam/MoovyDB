//
//  MovieDetailsResponse.swift
//  GluUpMovyDB
//
//  Created by Denis on 09.08.2022.
//

import Foundation

struct MovieDetailsResponse: Codable {
    let id: Int
    let title: String
    let originalLanguage: String
    let runtime: Int?
    let voteAverage: Double
    let releaseDate: String
    let popularity: Double
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case title = "title"
        case originalLanguage = "original_language"
        case runtime = "runtime"
        case voteAverage = "vote_average"
        case releaseDate = "release_date"
        case popularity = "popularity"
    }
}
