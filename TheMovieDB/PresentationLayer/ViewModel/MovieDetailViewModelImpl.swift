//
//  MovieDetailViewModelImpl.swift
//  TheMovieDB
//
//  Created by Muhammad Syafrizal on 09/02/23.
//

import Foundation
import RxSwift
import RxRelay

class MovieDetailViewModelImpl: MovieDetailViewModel {
    var lastPage: Int?
    private var _errors: PublishRelay<Error> = PublishRelay()
    private var _review: PublishRelay<[Data.ReviewEntity]> = PublishRelay()
    private var _videos: PublishRelay<[Data.VideoDataEntity]> = PublishRelay()
    private var disposeBag = DisposeBag()
    
    var movieRepository: MovieRepository
    
    init(
        movieRepository: MovieRepository
    ) {
        self.movieRepository = movieRepository
    }
    
    var errors: RxSwift.Observable<Error> {
        _errors.asObservable()
    }
    
    var reviews: Observable<[Data.ReviewEntity]> {
        _review.asObservable()
    }
    
    var videos: Observable<[Data.VideoDataEntity]> {
        _videos.asObservable()
    }
    
    func getReviews(movieId: Int, page: Int) {
        movieRepository
            .getReview(movieId: movieId, page: page)
            .subscribe(
                onSuccess: { [weak self] data in
                    self?._review.accept(data)
                },
                onError: { [weak self] error in
                    self?._errors.accept(error)
                }
            ).disposed(by: disposeBag)
    }
    
    func getVideos(movieId: Int) {
        movieRepository
            .getMovieVideos(movieId: movieId)
            .subscribe(
                onSuccess: { [weak self] data in
                    print(data)
                    self?._videos.accept(data)
                },
                onError: { [weak self] error in
                    print(error)
                    self?._errors.accept(error)
                }
            ).disposed(by: disposeBag)
    }
}
