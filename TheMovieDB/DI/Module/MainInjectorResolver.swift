//
//  MainInjectorResolver.swift
//  TheMovieDB
//
//  Created by Muhammad Syafrizal on 09/02/23.
//

import Foundation
import Cleanse

class MainInjectorResolver: InjectorResolver {
    private let splashVcInjector: Provider<PropertyInjector<ViewController>>

    init(splashVcInjector: Provider<PropertyInjector<ViewController>>) {
        self.splashVcInjector = splashVcInjector
    }

    func inject(_ viewController: ViewController) {
        splashVcInjector.get().injectProperties(into: viewController)
    }
}
