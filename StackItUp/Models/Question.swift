//
//  Question.swift
//  StackOverflow
//
//  Created by mcs on 3/2/20.
//  Copyright © 2020 MCS. All rights reserved.
//

import Foundation

// swiftlint:disable identifier_name
struct SOResponse: Codable {
    let items: [Question]?
    let has_more: Bool?
}

struct Question: Codable {
    let tags: [String]?
    let owner: Owner?
    let is_answered: Bool?
    let view_count: Int?
    let accepted_answer_id: Int?
    let answer_count: Int?
    let score: Int?
    let last_activity_date: Int?
    let creation_date: Int?
    let last_edit_date: Int?
    let question_id: Int?
    let link: String?
    let title: String?
}

struct Owner: Codable {
    let reputation: Int?
    let user_id: Int?
    let user_type: String?
    let profile_image: String?
    let display_name: String?
    let link: String?
}
