//
//  Question.swift
//  StackOverflow
//
//  Created by mcs on 3/2/20.
//  Copyright © 2020 MCS. All rights reserved.
//

import Foundation

// swiftlint:disable trailing_whitespace
// swiftlint:disable identifier_name
struct SOResponse : Codable {
    let items : [Items]?
    let has_more : Bool?
//    let quota_max : Int?
//    let quota_remaining : Int?

//    enum CodingKeys: String, CodingKey {
//
//        case items = "items"
//        case has_more = "has_more"
//        case quota_max = "quota_max"
//        case quota_remaining = "quota_remaining"
//    }
//
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        items = try values.decodeIfPresent([Items].self, forKey: .items)
//        has_more = try values.decodeIfPresent(Bool.self, forKey: .has_more)
//        quota_max = try values.decodeIfPresent(Int.self, forKey: .quota_max)
//        quota_remaining = try values.decodeIfPresent(Int.self, forKey: .quota_remaining)
//    }
}

struct Items : Codable {
    let tags : [String]?
    let owner : Owner?
    let is_answered : Bool?
    let view_count : Int?
    let accepted_answer_id : Int?
    let answer_count : Int?
    let score : Int?
    let last_activity_date : Int?
    let creation_date : Int?
    let last_edit_date : Int?
    let question_id : Int?
    let link : String?
    let title : String?
//
//    enum CodingKeys: String, CodingKey {
//        case tags = "tags"
//        case owner = "owner"
//        case is_answered = "is_answered"
//        case view_count = "view_count"
//        case accepted_answer_id = "accepted_answer_id"
//        case answer_count = "answer_count"
//        case score = "score"
//        case last_activity_date = "last_activity_date"
//        case creation_date = "creation_date"
//        case last_edit_date = "last_edit_date"
//        case question_id = "question_id"
//        case link = "link"
//        case title = "title"
//    }

//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        tags = try values.decodeIfPresent([String].self, forKey: .tags)
//        owner = try values.decodeIfPresent(Owner.self, forKey: .owner)
//        is_answered = try values.decodeIfPresent(Bool.self, forKey: .is_answered)
//        view_count = try values.decodeIfPresent(Int.self, forKey: .view_count)
//        accepted_answer_id = try values.decodeIfPresent(Int.self, forKey: .accepted_answer_id)
//        answer_count = try values.decodeIfPresent(Int.self, forKey: .answer_count)
//        score = try values.decodeIfPresent(Int.self, forKey: .score)
//        last_activity_date = try values.decodeIfPresent(Int.self, forKey: .last_activity_date)
//        creation_date = try values.decodeIfPresent(Int.self, forKey: .creation_date)
//        last_edit_date = try values.decodeIfPresent(Int.self, forKey: .last_edit_date)
//        question_id = try values.decodeIfPresent(Int.self, forKey: .question_id)
//        link = try values.decodeIfPresent(String.self, forKey: .link)
//        title = try values.decodeIfPresent(String.self, forKey: .title)
//    }
}

struct Owner : Codable {
    let reputation : Int?
    let user_id : Int?
    let user_type : String?
    let profile_image : String?
    let display_name : String?
    let link : String?

    enum CodingKeys: String, CodingKey {
        case reputation = "reputation"
        case user_id = "user_id"
        case user_type = "user_type"
        case profile_image = "profile_image"
        case display_name = "display_name"
        case link = "link"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        reputation = try values.decodeIfPresent(Int.self, forKey: .reputation)
        user_id = try values.decodeIfPresent(Int.self, forKey: .user_id)
        user_type = try values.decodeIfPresent(String.self, forKey: .user_type)
        profile_image = try values.decodeIfPresent(String.self, forKey: .profile_image)
        display_name = try values.decodeIfPresent(String.self, forKey: .display_name)
        link = try values.decodeIfPresent(String.self, forKey: .link)
    }
}
