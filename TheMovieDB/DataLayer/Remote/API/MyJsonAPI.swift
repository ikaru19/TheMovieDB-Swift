//
//  MyJsonAPI.swift
//  TheMovieDB
//
//  Created by Muhammad Syafrizal on 09/02/23.
//

import Foundation

final class MyJsonAPI {
    private(set) var jsonRequestService: JsonRequest

    init(apiService: JsonRequest) {
        jsonRequestService = apiService
    }
}
