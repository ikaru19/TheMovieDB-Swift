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
    var detailVcProvider: Provider<Presentation.UiKit.MovieDetailViewController>
    
    init(
        homeVcProvider: Provider<Presentation.UiKit.GenreViewController>,
        movieVcProvider: Provider<Presentation.UiKit.MovieListViewController>,
        detailVcProvider: Provider<Presentation.UiKit.MovieDetailViewController>
    ) {
        self.homeVcProvider = homeVcProvider
        self.movieVcProvider = movieVcProvider
        self.detailVcProvider = detailVcProvider
    }

    func instantiateHomeViewController() -> Provider<Presentation.UiKit.GenreViewController> {
        homeVcProvider
    }
    
    func instantiateMoviewListViewController() -> Cleanse.Provider<Presentation.UiKit.MovieListViewController> {
        movieVcProvider
    }
    
    func instantiateDetailViewController() -> Cleanse.Provider<Presentation.UiKit.MovieDetailViewController> {
        detailVcProvider
    }
}
