//
//  MovieRepository.swift
//  TheMovieDB
//
//  Created by Muhammad Syafrizal on 09/02/23.
//

import Foundation
import RxSwift

protocol MovieRepository: AnyObject {
    func getMovie(byGenreId: Int, page: Int) -> Single<[Data.MovieEntity]>
    func getReview(movieId: Int, page: Int) -> Single<[Data.ReviewEntity]>
    func getMovieVideos(movieId: Int) -> Single<[Data.VideoDataEntity]>
}
