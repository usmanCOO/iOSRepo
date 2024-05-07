//
//  Notification.swift
//  DealDoc
//
//  Created by Mackbook on 02/05/2023.
//

import Foundation
struct Notification : Codable {
    let id : Int?
    let message : String?
    let notification_type : String?
    let url : String?
    let read_status : Bool?
    let createdAt : String?
    let updatedAt : String?
    let created_by : String?
    let send_to : Int?
    let deal_Id : Int?
    let comment_Id : Int?
    let deal : Deal?
    let comment : Comment?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case message = "message"
        case notification_type = "notification_type"
        case url = "url"
        case read_status = "read_status"
        case createdAt = "createdAt"
        case updatedAt = "updatedAt"
        case created_by = "created_by"
        case send_to = "send_to"
        case deal_Id = "deal_Id"
        case comment_Id = "comment_Id"
        case deal = "Deal"
        case comment = "Comment"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        notification_type = try values.decodeIfPresent(String.self, forKey: .notification_type)
        url = try values.decodeIfPresent(String.self, forKey: .url)
        read_status = try values.decodeIfPresent(Bool.self, forKey: .read_status)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
        created_by = try values.decodeIfPresent(String.self, forKey: .created_by)
        send_to = try values.decodeIfPresent(Int.self, forKey: .send_to)
        deal_Id = try values.decodeIfPresent(Int.self, forKey: .deal_Id)
        comment_Id = try values.decodeIfPresent(Int.self, forKey: .comment_Id)
        deal = try values.decodeIfPresent(Deal.self, forKey: .deal)
        comment = try values.decodeIfPresent(Comment.self, forKey: .comment)
    }

}


struct Comment : Codable {
    let statement : String?

    enum CodingKeys: String, CodingKey {

        case statement = "statement"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        statement = try values.decodeIfPresent(String.self, forKey: .statement)
    }

}
