//
//  MyAFRequest+JsonRequest.swift
//  TheMovieDB
//
//  Created by Muhammad Syafrizal on 09/02/23.
//

import Foundation
import RxSwift
import RxAlamofire
import Alamofire

extension MyAFRequest: JsonRequest {
    func get<T: Decodable>(
        to endPoint: String,
        param: [String : Any],
        header: [String : String],
        type: T.Type
    ) -> RxSwift.Single<T>{
        let endPoint = injectBaseUrl(endPoint: endPoint)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return session.rx.request(
                .get,
                endPoint,
                parameters: injectDefaultParam(with: param),
                encoding: URLEncoding.default,
                headers: HTTPHeaders(header)
        )
        .validate()
        .flatMap {
            $0.rx.decodable(decoder: decoder)
        }
        .asSingle()
    }
}
