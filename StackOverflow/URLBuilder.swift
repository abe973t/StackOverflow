//
//  URLBuilder.swift
//  StackOverflow
//
//  Created by mcs on 2/27/20.
//  Copyright © 2020 MCS. All rights reserved.
//

import Foundation

// swiftlint:disable trailing_whitespace
// swiftlint:disable line_length
enum Sorting: String {
    case activity = "activity"
    case upVotes = "votes"
    case creationDate = "creation"
    case relevance = "relevance"
}

enum Order: String {
    case desc
    case asc
}

class URLBuilder {
    static func searchQuestion(containing query: String, sortedBy sort: Sorting, displayOrder order: Order, tags: String...) -> String {
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.stackexchange.com"
        components.path = "/2.2/search"
        components.queryItems = [
            URLQueryItem(name: "order", value: order.rawValue),
            URLQueryItem(name: "sort", value: sort.rawValue),
            URLQueryItem(name: "tagged", value: tags.joined(separator: ";")),
            URLQueryItem(name: "intitle", value: query),
            URLQueryItem(name: "site", value: "stackoverflow")
        ]

        // Getting a URL from our components is as simple as
        // accessing the 'url' property.
        return components.url?.absoluteString ?? "Error"
    }
}
