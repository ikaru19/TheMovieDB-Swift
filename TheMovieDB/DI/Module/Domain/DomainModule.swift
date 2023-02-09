//
//  DomainModule.swift
//  TheMovieDB
//
//  Created by Muhammad Syafrizal on 09/02/23.
//

import Foundation
import Cleanse

struct DomainModule: Module {
    static func configure(binder: UnscopedBinder) {
        binder.bind(GenreRepository.self)
                .to(factory: GenreRepositoryImpl.init)
        binder.bind(MovieRepository.self)
                .to(factory: MovieRepositoryImpl.init)
    }
}
