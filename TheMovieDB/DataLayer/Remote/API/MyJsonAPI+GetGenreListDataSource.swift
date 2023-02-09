//
//  MyJsonAPI+GetGenreListDataSource.swift
//  TheMovieDB
//
//  Created by Muhammad Syafrizal on 09/02/23.
//

import Foundation
import RxSwift
import Alamofire
import RxAlamofire

extension MyJsonAPI: GetMovieGenreListDataSource {
    func getGenreList() -> RxSwift.Single<[Data.GenreEntity]> {
        let endpoint = "genre/movie/list"
        return jsonRequestService.get(
            to: endpoint,
            param: [:],
            header: [:],
            type: ApiDataGenreResponseImpl<[Data.GenreEntity]>.self
        ).map {
            try $0.mapToData()
        }
    }
}
