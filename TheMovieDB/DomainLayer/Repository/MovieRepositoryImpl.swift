//
//  MovieRepositoryImpl.swift
//  TheMovieDB
//
//  Created by Muhammad Syafrizal on 09/02/23.
//

import Foundation
import RxSwift

class MovieRepositoryImpl: MovieRepository {
    
    private var getMovieListDataSource: GetMovieListDataSource
    private var getReviewDataSource: GetMovieReviewListDataSource
    
    init(
        getMovieListDataSource: GetMovieListDataSource,
        getReviewDataSource: GetMovieReviewListDataSource
    ) {
        self.getMovieListDataSource = getMovieListDataSource
        self.getReviewDataSource = getReviewDataSource
    }
    
    func getMovie(byGenreId: Int, page: Int) -> RxSwift.Single<[Data.MovieEntity]> {
        getMovieListDataSource
            .getMovie(withGenreId: byGenreId, page: page)
    }
    
    func getReview(movieId: Int, page: Int) -> RxSwift.Single<[Data.ReviewEntity]> {
        getReviewDataSource.getMovieReview(withMovieId: movieId, page: page)
    }
    
    func getMovieVideos(movieId: Int) -> RxSwift.Single<[Data.VideoDataEntity]> {
        getMovieListDataSource.getMovieVideos(movieId: movieId)
    }
}
