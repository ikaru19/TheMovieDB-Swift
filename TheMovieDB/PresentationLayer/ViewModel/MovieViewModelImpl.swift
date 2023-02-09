//
//  MovieViewModelImpl.swift
//  TheMovieDB
//
//  Created by Muhammad Syafrizal on 09/02/23.
//

import Foundation
import RxSwift
import RxRelay

class MovieViewModelImpl: MovieViewModel {
    var lastPage: Int?
    private var _errors: PublishRelay<Error> = PublishRelay()
    private var _movies: PublishRelay<[Data.MovieEntity]> = PublishRelay()
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
    
    var movies: RxSwift.Observable<[Data.MovieEntity]> {
        _movies.asObservable()
    }
    
    func getGameList(withGenreId: Int, page: Int) {
        movieRepository
            .getMovie(byGenreId: withGenreId, page: page)
            .subscribe(
                onSuccess: { [weak self] data in
                    self?._movies.accept(data)
                },
                onError: { [weak self] error in
                    self?._errors.accept(error)
                }
            ).disposed(by: disposeBag)
    }
}
