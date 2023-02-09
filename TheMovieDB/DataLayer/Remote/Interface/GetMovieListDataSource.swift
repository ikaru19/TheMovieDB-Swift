//
//  GetMovieListDataSource.swift
//  TheMovieDB
//
//  Created by Muhammad Syafrizal on 09/02/23.
//

import Foundation
import RxSwift
import Alamofire

protocol GetMovieListDataSource: AnyObject {
    func getMovie(withGenreId: Int, page: Int) -> Single<[Data.MovieEntity]>
    func getMovieVideos(movieId: Int) -> Single<[Data.VideoDataEntity]>
}
