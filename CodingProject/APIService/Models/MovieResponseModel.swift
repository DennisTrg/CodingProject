//
//  MovieResponseModel.swift
//  CodingProject
//
//  Created by Tung Truong on 23/03/2023.
//

import Foundation

struct MovieResponseModel: Codable {
    let search: [Movie]?
    let response: String
    
    enum CodingKeys: String, CodingKey {
        case search = "Search"
        case response = "Response"
    }
}

struct Movie: Codable {
    let title: String
    let year: String
    let imdbID: String
    let type: String
    let poster: String
    
    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case imdbID
        case type = "Type"
        case poster = "Poster"
    }
}
