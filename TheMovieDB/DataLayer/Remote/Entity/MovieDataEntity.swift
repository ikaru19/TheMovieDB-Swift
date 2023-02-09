//
//  MovieDataEntity.swift
//  TheMovieDB
//
//  Created by Muhammad Syafrizal on 09/02/23.
//

import Foundation

extension Data {
    struct MovieEntity: Codable {
        var adult: Bool
        var backdropPath: String?
        var genreIds: [Int]
        var id: Int
        var originalLanguage: String
        var originalTitle: String
        var overview: String
        var popularity: Double
        var posterPath: String = ""
        var releaseDate: String = ""
        var title: String
        var video: Bool
        var voteAverage: Double
        var voteCount: Int
    }
}
