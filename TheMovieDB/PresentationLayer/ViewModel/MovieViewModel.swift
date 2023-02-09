//
//  MovieViewModel.swift
//  TheMovieDB
//
//  Created by Muhammad Syafrizal on 09/02/23.
//

import Foundation
import RxSwift

protocol MovieViewModel: AnyObject {
    var errors: Observable<Error> { get }
    var movies: Observable<[Data.MovieEntity]> { get }
    var lastPage: Int? { get set }
    
    func getGameList(withGenreId: Int, page: Int)
}
