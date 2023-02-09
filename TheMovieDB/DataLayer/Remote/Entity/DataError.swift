//
//  DataError.swift
//  TheMovieDB
//
//  Created by Muhammad Syafrizal on 09/02/23.
//

import Foundation

extension Data {
    struct DataError: Error {
        enum Reason {
            case noData
            case selfIsNull
        }
        let reason: Reason
        let line: Int?
        let column: Int?

        init(reason: Reason, line: Int? = nil, column: Int? = nil) {
            self.reason = reason
            self.line = line
            self.column = column
        }
    }

}
