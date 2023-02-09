//
//  MyJsonAPI+GetMoviewReviewListDataSource.swift
//  TheMovieDB
//
//  Created by Muhammad Syafrizal on 09/02/23.
//

import Foundation
import RxSwift
import Alamofire
import RxAlamofire

extension MyJsonAPI: GetMovieReviewListDataSource {
    func getMovieReview(withMovieId: Int, page: Int) -> RxSwift.Single<[Data.ReviewEntity]> {
        let endpoint = "movie/\(withMovieId)/reviews"
        let params : [String: Any?] = [
            "page": page,
        ]
        return jsonRequestService.get(
            to: endpoint,
            param: params,
            header: [:],
            type: ApiDataResponseImpl<[Data.ReviewEntity]>.self
        ).map {
            try $0.mapToData()
        }
    }
}
