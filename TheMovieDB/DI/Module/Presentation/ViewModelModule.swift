//
//  ViewModelModule.swift
//  TheMovieDB
//
//  Created by Muhammad Syafrizal on 09/02/23.
//

import Foundation
import Cleanse

struct ViewModelModule: Module {
    static func configure(binder: UnscopedBinder) {
        binder.bind(GenreViewModel.self)
                .to(factory: GenreViewModelImpl.init)
        binder.bind(MovieViewModel.self)
                .to(factory: MovieViewModelImpl.init)
    }
}
