//
//  CoreModule.swift
//  TheMovieDB
//
//  Created by Muhammad Syafrizal on 09/02/23.
//

import Foundation
import Cleanse

struct CoreModule: Module {
    static func configure(binder: SingletonScope) {
        binder.include(module: DataModule.self)
        binder.include(module: DomainModule.self)
        binder.include(module: PresentationModule.self)

        binder.bind(InjectorResolver.self)
                .to(factory: MainInjectorResolver.init)
        binder.bind(ViewControllerResolver.self)
                .to(factory: MainViewControllerResolver.init)
    }
}
