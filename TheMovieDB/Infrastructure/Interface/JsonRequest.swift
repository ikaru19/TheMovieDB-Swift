//
//  JsonRequest.swift
//  TheMovieDB
//
//  Created by Muhammad Syafrizal on 09/02/23.
//

import Foundation
import RxSwift
import RxAlamofire
import Alamofire

protocol JsonRequest: AnyObject {
    func get<T: Decodable>(
            to endPoint: String,
            param: [String: Any],
            header: [String: String],
            type: T.Type
    ) -> Single<T>
}
