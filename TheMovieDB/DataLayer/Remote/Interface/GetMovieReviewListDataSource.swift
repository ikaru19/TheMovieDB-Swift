//
//  GetMovieReviewListDataSource.swift
//  TheMovieDB
//
//  Created by Muhammad Syafrizal on 09/02/23.
//

import Foundation
import RxSwift
import Alamofire

protocol GetMovieReviewListDataSource: AnyObject {
    func getMovieReview(withMovieId: Int, page: Int) -> Single<[Data.ReviewEntity]>
}
