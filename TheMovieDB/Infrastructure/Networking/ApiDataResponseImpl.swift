//
//  ApiDataResponseImpl.swift
//  TheMovieDB
//
//  Created by Muhammad Syafrizal on 09/02/23.
//

import Foundation

// MARK: - GENRE RESPONSE
struct ApiDataGenreResponseImpl<T: Codable>: ApiDataResponse {
    typealias DataResponse = T

    enum CodingKeys: String, CodingKey {
        case data = "genres"
    }
    var data: T?
}

extension ApiDataGenreResponseImpl where T: Codable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        data = try container.decodeIfPresent(T.self, forKey: .data)
    }
}

// MARK: - NORMAL RESPONSE
struct ApiDataResponseImpl<T: Codable>: ApiDataResponse {
    typealias DataResponse = T

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case page = "page"
        case total_pages = "total_pages"
        case total_results = "total_results"
        case data = "results"
    }

    var id: Int?
    var page: Int?
    var total_pages: Int?
    var total_results: Int?
    var data: T?
}

extension ApiDataResponseImpl where T: Codable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decodeIfPresent(Int.self, forKey: .id)
        page = try container.decodeIfPresent(Int.self, forKey: .page)
        total_pages = try container.decodeIfPresent(Int.self, forKey: .total_pages)
        total_results = try container.decodeIfPresent(Int.self, forKey: .total_results)
        data = try container.decodeIfPresent(T.self, forKey: .data)
    }
}


extension ApiDataResponse {
    func mapToData() throws -> DataResponse {
        guard let data = data else {
            throw Data.DataError(reason: .selfIsNull)
        }
        return data
    }

    func mapToNullableData() throws -> DataResponse? {
        data
    }
}

protocol ApiResponseProtocol: Codable {
}

protocol ApiDataResponse: ApiResponseProtocol {
    associatedtype DataResponse

    var data: DataResponse? { get }
}

