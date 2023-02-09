//
//  GenreViewModel.swift
//  TheMovieDB
//
//  Created by Muhammad Syafrizal on 09/02/23.
//

import Foundation
import RxSwift

protocol GenreViewModel: AnyObject {
    var errors: Observable<Error> { get }
    var genres: Observable<[Data.GenreEntity]> { get }
    
    func getGenreList()
}
