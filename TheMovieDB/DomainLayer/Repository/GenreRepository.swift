//
//  GenreRepository.swift
//  TheMovieDB
//
//  Created by Muhammad Syafrizal on 09/02/23.
//

import Foundation
import RxSwift

protocol GenreRepository: AnyObject {
    func getGenre() -> Single<[Data.GenreEntity]>
}
