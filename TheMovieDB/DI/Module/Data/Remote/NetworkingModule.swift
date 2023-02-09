//
//  NetworkingModule.swift
//  TheMovieDB
//
//  Created by Muhammad Syafrizal on 09/02/23.
//

import Foundation
import Cleanse
import Alamofire

struct MovieAPIKey: Tag {
    typealias Element = String
}

struct Scope: Tag {
    typealias Element = String
}

struct MyBaseUrl: Tag {
    typealias Element = String
}

struct MyNetworkTimeOut: Tag {
    typealias Element = TimeInterval
}

struct MyApiQueueRequest: Tag {
    typealias Element = DispatchQueue
}

struct MyAPIQueueSerialization: Tag {
    typealias Element = DispatchQueue
}

struct NetworkingModule: Module {
    static func configure(binder: SingletonScope) {
        binder.bind(String.self)
                .tagged(with: MovieAPIKey.self)
                .sharedInScope()
                .to(value: Constants.API_KEY)

        binder.bind(String.self)
            .tagged(with: MyBaseUrl.self)
            .to {
                Constants.BASE_API_URL
            }
        binder.bind(JsonRequest.self)
                .sharedInScope()
                .to(factory: MyAFRequest.init)
        
        binder.bind(DispatchQueue.self)
                .tagged(with: MyApiQueueRequest.self)
                .sharedInScope()
                .to(value: DispatchQueue.apiRequest)

        binder.bind(DispatchQueue.self)
                .tagged(with: MyAPIQueueSerialization.self)
                .sharedInScope()
                .to(value: DispatchQueue.apiSerialization)

        binder.bind(TimeInterval.self)
                .tagged(with: MyNetworkTimeOut.self)
                .sharedInScope()
                .to {
                    120
                }
        binder.bind(RequestInterceptor?.self)
                .sharedInScope()
                .to {
                    APIQueue.shared.apiQueueInterceptor
                }
        binder.bind(Session.self)
                .sharedInScope()
                .to { (
                        timeout: TaggedProvider<MyNetworkTimeOut>,
                        apiRequest: TaggedProvider<MyApiQueueRequest>,
                        apiSerialization: TaggedProvider<MyAPIQueueSerialization>,
                        interceptorProvider: RequestInterceptor?
                ) in
                    let configuration = URLSessionConfiguration.af.default
                    configuration.timeoutIntervalForRequest = timeout.get()

                    let session = Session(
                            configuration: configuration,
                            requestQueue: apiRequest.get(),
                            serializationQueue: apiSerialization.get(),
                            interceptor: interceptorProvider
                    )

                    return session
                }
    }
}
