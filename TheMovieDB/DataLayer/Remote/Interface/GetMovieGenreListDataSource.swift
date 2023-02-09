//
//  GetMovieGenreListDataSource.swift
//  TheMovieDB
//
//  Created by Muhammad Syafrizal on 09/02/23.
//

import Foundation
import RxSwift
import Alamofire

protocol GetMovieGenreListDataSource: AnyObject {
    func getGenreList() -> Single<[Data.GenreEntity]>
}
