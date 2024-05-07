//
//  DealSharedData.swift
//  DealDoc
//
//  Created by Asad Khan on 10/14/22.
//

import Foundation
struct DealSharedData : Codable {
    let id : Int?
    let createdAt : String?
    let updatedAt : String?
    let description : String?
    let userId : Int?
    let dealId : Int?
    let deal : Deal?
    let user : User?
    let shared_user : User?
    var isExpanded: Bool = false
    let unread: Int?
   

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case createdAt = "createdAt"
        case updatedAt = "updatedAt"
        case description = "description"
        case userId = "userId"
        case dealId = "dealId"
        case deal = "Deal"
        case user = "creator"
        case shared_user = "shared_user"
        case unread = "unread"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        userId = try values.decodeIfPresent(Int.self, forKey: .userId)
        dealId = try values.decodeIfPresent(Int.self, forKey: .dealId)
        deal = try values.decodeIfPresent(Deal.self, forKey: .deal)
        user = try values.decodeIfPresent(User.self, forKey: .user)
        shared_user = try values.decodeIfPresent(User.self, forKey: .shared_user)
        unread = try values.decodeIfPresent(Int.self, forKey: .unread)
    }

}

struct Deal : Codable {
    let deal_name : String?
    let id : Int?
    let color : String?
    let investment_size : Int?
    let closed_date : String?
    let updatedAt : String?
    
    enum CodingKeys: String, CodingKey {

        case deal_name = "deal_name"
        case id = "id"
        case color = "color"
        case investment_size = "investment_size"
        case closed_date = "closed_date"
        case updatedAt = "updatedAt"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        deal_name = try values.decodeIfPresent(String.self, forKey: .deal_name)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        color = try values.decodeIfPresent(String.self, forKey: .color)
        investment_size = try values.decodeIfPresent(Int.self, forKey: .investment_size)
        closed_date = try values.decodeIfPresent(String.self, forKey: .closed_date)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
    }

}

struct User : Codable {
    let fullName : String?
    let id : Int?
    let email : String?

    enum CodingKeys: String, CodingKey {

        case fullName = "fullName"
        case id = "id"
        case email = "email"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        fullName = try values.decodeIfPresent(String.self, forKey: .fullName)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        email = try values.decodeIfPresent(String.self, forKey: .email)
    }

}

