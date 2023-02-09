//
//  ReviewDataEntity.swift
//  TheMovieDB
//
//  Created by Muhammad Syafrizal on 09/02/23.
//

import Foundation

extension Data {
    struct ReviewEntity: Codable {
        var author: String
        var authorDetails: AuthorDetailEntity
        var content: String
        var createdAt: String
        var id: String
        var updatedAt: String
        var url: String
    }
    struct AuthorDetailEntity: Codable {
        var name: String
        var username: String
        var avatarPath: String?
        var rating: Double?
    }
}
