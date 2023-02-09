//
//  MovieDetailViewModel.swift
//  TheMovieDB
//
//  Created by Muhammad Syafrizal on 09/02/23.
//

import Foundation
import RxSwift

protocol MovieDetailViewModel: AnyObject {
    var errors: Observable<Error> { get }
    var reviews: Observable<[Data.ReviewEntity]> { get }
    var videos: Observable<[Data.VideoDataEntity]> { get }
    var lastPage: Int? { get set }
    
    func getReviews(movieId: Int, page: Int)
    func getVideos(movieId: Int)
}
