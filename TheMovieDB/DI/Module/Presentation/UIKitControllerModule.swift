//
//  UIKitControllerModule.swift
//  TheMovieDB
//
//  Created by Muhammad Syafrizal on 09/02/23.
//

import Foundation
import Cleanse

struct UIKitControllerModule: Module {
    static func configure(binder: UnscopedBinder) {
        binder.bind(Presentation.UiKit.GenreViewController.self)
            .to {
                Presentation.UiKit.GenreViewController(nibName: nil, bundle: nil, viewModel: $0)
            }
        binder.bind(Presentation.UiKit.MovieListViewController.self)
            .to {
                Presentation.UiKit.MovieListViewController(nibName: nil, bundle: nil, viewModel: $0)
            }
    }
}
