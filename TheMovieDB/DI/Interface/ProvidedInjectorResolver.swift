//
//  ProvidedInjectorResolver.swift
//  TheMovieDB
//
//  Created by Muhammad Syafrizal on 09/02/23.
//

import Foundation

protocol ProvideInjectorResolver: AnyObject {
    var injectorResolver: InjectorResolver { get }
}
