//
//  MainPageModule.swift
//  TheMovieDB
//
//  Created by Muhammad Syafrizal on 09/02/23.
//

import Foundation
import Cleanse

struct MainPageModule: Module {
    static func configure(binder: UnscopedBinder) {
        binder.bindPropertyInjectionOf(ViewController.self)
                .to(injector: ViewController.injectProperties)
    }
}
