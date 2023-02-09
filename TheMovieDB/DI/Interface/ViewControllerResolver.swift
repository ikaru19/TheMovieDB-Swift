//
//  ViewControllerResolver.swift
//  TheMovieDB
//
//  Created by Muhammad Syafrizal on 09/02/23.
//

import Foundation
import Cleanse

protocol ViewControllerResolver: AnyObject {
    func instantiateHomeViewController() -> Provider<Presentation.UiKit.GenreViewController>
    func instantiateMoviewListViewController() -> Provider<Presentation.UiKit.MovieListViewController>
}
