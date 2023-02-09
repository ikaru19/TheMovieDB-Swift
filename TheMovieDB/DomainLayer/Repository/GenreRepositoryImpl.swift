//
//  GenreRepositoryImpl.swift
//  TheMovieDB
//
//  Created by Muhammad Syafrizal on 09/02/23.
//

import Foundation
import RxSwift

class GenreRepositoryImpl: GenreRepository {
    private var getGenreDataSource: GetMovieGenreListDataSource
    
    init(
        getGenreDataSource: GetMovieGenreListDataSource
    ) {
        self.getGenreDataSource = getGenreDataSource
    }
    func getGenre() -> RxSwift.Single<[Data.GenreEntity]> {
        getGenreDataSource.getGenreList()
    }
}
