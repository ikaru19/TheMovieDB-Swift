//
//  MyJsonAPI+getMovieListDataSource.swift
//  TheMovieDB
//
//  Created by Muhammad Syafrizal on 09/02/23.
//

import Foundation
import RxSwift
import Alamofire
import RxAlamofire

extension MyJsonAPI: GetMovieListDataSource {
    func getMovie(withGenreId: Int, page: Int) -> RxSwift.Single<[Data.MovieEntity]> {
        let endpoint = "discover/movie"
        let params : [String: Any?] = [
            "with_genres": withGenreId,
            "page": page,
        ]
        return jsonRequestService.get(
            to: endpoint,
            param: params,
            header: [:],
            type: ApiDataResponseImpl<[Data.MovieEntity]>.self
        ).map {
            try $0.mapToData()
        }
    }
    
    func getMovieVideos(movieId: Int) -> RxSwift.Single<[Data.VideoDataEntity]> {
        let endpoint = "movie/\(movieId)/videos"
        return jsonRequestService.get(
            to: endpoint,
            param: [:],
            header: [:],
            type: ApiDataResponseImpl<[Data.VideoDataEntity]>.self
        ).map {
            try $0.mapToData()
        }
    }
    
}
