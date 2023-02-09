//
//  InjectorResolver.swift
//  TheMovieDB
//
//  Created by Muhammad Syafrizal on 09/02/23.
//

import Foundation

protocol InjectorResolver: AnyObject {
    func inject(_ viewController: ViewController)
}
