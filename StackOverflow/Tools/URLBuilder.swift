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
    static func authURL(clientID: Int, scope: String, redirectURI: String) -> URL? {
        var components = URLComponents()

        components.scheme = "https"
        components.host = "stackoverflow.com"
        components.path = "/oauth/dialog"
        components.queryItems = [
            URLQueryItem(name: "client_id", value: String(clientID)),
            URLQueryItem(name: "scope", value: scope),
            URLQueryItem(name: "redirect_uri", value: redirectURI)
        ]

        return components.url
    }
    
    static func searchQuestion(containing query: String, sortedBy sort: Sorting, displayOrder order: Order, tags: String...) -> URL? {
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

        return components.url
    }
    
    static func createQuestionURL() -> URL? {
        var components = URLComponents()

        components.scheme = "https"
        components.host = "api.stackexchange.com"
        components.path = "/2.2/questions/add/"

        return components.url
    }
    
    static func createAnswerURL(questionID: Int) -> URL? {
        var components = URLComponents()

        components.scheme = "https"
        components.host = "api.stackexchange.com"
        components.path = "/2.2/questions/\(questionID)/answers/add/"

        return components.url
    }
    
    static func upvoteAnswerURL(questionID: Int) -> URL? {
        var components = URLComponents()

        components.scheme = "https"
        components.host = "api.stackexchange.com"
        components.path = "/2.2/questions/\(questionID)/upvote/"

        return components.url
    }
    
    static func downvoteAnswerURL(questionID: Int) -> URL? {
        var components = URLComponents()

        components.scheme = "https"
        components.host = "api.stackexchange.com"
        components.path = "/2.2/questions/\(questionID)/downvote/"

        return components.url
    }
    
    static func fetchAnswersURL(questionID: Int, sorting: Sorting) -> URL? {
        var components = URLComponents()

        components.scheme = "https"
        components.host = "api.stackexchange.com"
        components.path = "/2.2/questions/\(questionID)/answers"
        components.queryItems = [
            URLQueryItem(name: "order", value: Order.desc.rawValue),
            URLQueryItem(name: "sort", value: sorting.rawValue),
            URLQueryItem(name: "site", value: "stackoverflow")
        ]

        return components.url
    }
}
