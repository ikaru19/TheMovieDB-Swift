//
//  VideoDataEntity.swift
//  TheMovieDB
//
//  Created by Muhammad Syafrizal on 09/02/23.
//

import Foundation

extension Data {
    struct VideoDataEntity: Codable {
        var name: String
        var key: String
        var type: String
        var site: String
    }
}
