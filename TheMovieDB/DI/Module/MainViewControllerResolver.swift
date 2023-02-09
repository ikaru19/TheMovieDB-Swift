//
//  MainViewControllerResolver.swift
//  TheMovieDB
//
//  Created by Muhammad Syafrizal on 09/02/23.
//

import Foundation
import Cleanse

class MainViewControllerResolver: ViewControllerResolver {
    var homeVcProvider: Provider<Presentation.UiKit.GenreViewController>
    var movieVcProvider: Provider<Presentation.UiKit.MovieListViewController>
    
    init(
        homeVcProvider: Provider<Presentation.UiKit.GenreViewController>,
        movieVcProvider: Provider<Presentation.UiKit.MovieListViewController>
    ) {
        self.homeVcProvider = homeVcProvider
        self.movieVcProvider = movieVcProvider
    }

    func instantiateHomeViewController() -> Provider<Presentation.UiKit.GenreViewController> {
        homeVcProvider
    }
    
    func instantiateMoviewListViewController() -> Cleanse.Provider<Presentation.UiKit.MovieListViewController> {
        movieVcProvider
    }
    
}
