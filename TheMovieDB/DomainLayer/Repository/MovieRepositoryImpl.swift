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
    
    init(
        getMovieListDataSource: GetMovieListDataSource
    ) {
        self.getMovieListDataSource = getMovieListDataSource
    }
    
    func getMovie(byGenreId: Int, page: Int) -> RxSwift.Single<[Data.MovieEntity]> {
        getMovieListDataSource
            .getMovie(withGenreId: byGenreId, page: page)
    }
    
}
