//
//  UIKitModule.swift
//  TheMovieDB
//
//  Created by Muhammad Syafrizal on 09/02/23.
//

import Foundation
import Cleanse

struct UIKitModule: Module {
    static func configure(binder: SingletonScope) {
        binder.include(module: UIScreen.Module.self)
    }
}

extension UIScreen {
    /// This is a simple module that binds UIScreen.mainScreen() to UIScreen
    struct Module: Cleanse.Module {
        static func configure(binder: SingletonScope) {
            binder
                    .bind(UIScreen.self)
                    .sharedInScope()
                    .to {
                        UIScreen.main
                    }
        }
    }
}
