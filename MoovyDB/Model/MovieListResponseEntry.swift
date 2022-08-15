//
//  MovieListResponseEntry.swift
//  GluUpMovyDB
//
//  Created by Denis on 09.08.2022.
//

import Foundation

struct MovieListResponseEntry: Codable {
    let id: Int
    let title: String
    let posterPath: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case title = "title"
        case posterPath = "poster_path"
    }
}
