//
//  ProvidedViewControllerResolver.swift
//  TheMovieDB
//
//  Created by Muhammad Syafrizal on 09/02/23.
//

import Foundation

protocol ProvideViewControllerResolver: AnyObject {
    var vcResolver: ViewControllerResolver { get }
}
