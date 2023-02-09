//
//  DataModule.swift
//  TheMovieDB
//
//  Created by Muhammad Syafrizal on 09/02/23.
//

import Foundation
import Cleanse

struct DataModule: Module {
    static func configure(binder: SingletonScope) {
        binder.include(module: NetworkingModule.self)
        binder.include(module: MyAPIModule.self)

        // MARK: API
        binder.bind(GetMovieGenreListDataSource.self)
                .sharedInScope()
                .to { (api: MyJsonAPI) in
                    api
                }
        binder.bind(GetMovieListDataSource.self)
                .sharedInScope()
                .to { (api: MyJsonAPI) in
                    api
                }
        binder.bind(GetMovieReviewListDataSource.self)
                .sharedInScope()
                .to { (api: MyJsonAPI) in
                    api
                }
    }
}
