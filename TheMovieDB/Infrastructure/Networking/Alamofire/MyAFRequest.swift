//
//  MyAFRequest.swift
//  TheMovieDB
//
//  Created by Muhammad Syafrizal on 09/02/23.
//

import Foundation
import Cleanse
import RxSwift
import Alamofire

final class MyAFRequest {
    private var apiKey: String
    private var baseUrl: TaggedProvider<MyBaseUrl>
    private(set) var session: Session
    
    init(
            apiKey: TaggedProvider<MovieAPIKey>,
            session: Session,
            baseUrl: TaggedProvider<MyBaseUrl>
    ) {
        self.apiKey = apiKey.get()
        self.baseUrl = baseUrl
        self.session = session
    }

    static func isNetworkConnected() -> Bool {
        if let manager = NetworkReachabilityManager() {
            return manager.isReachable
        } else {
            return false
        }
    }
    
    func injectDefaultParam(with dict: [String: Any]) -> [String: Any] {
        var param = [String: Any]()
        param["api_key"] = apiKey
        param["language"] = "en-US"
        return param.merging(dict, uniquingKeysWith: { (_, new) in new })
    }

    func injectBaseUrl(endPoint: String) -> String {
        "\(baseUrl.get())\(endPoint)"
    }
}
