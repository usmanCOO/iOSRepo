//
//  UnReadCommentResponse.swift
//  DealDoc
//
//  Created by Mackbook on 02/05/2023.
//

import Foundation
struct UnReadCommentsResponse : Codable {
    let success : Bool?
    let message : String?
    let notification : [Notification]?
    let unread : Int?

    enum CodingKeys: String, CodingKey {

        case success = "success"
        case message = "message"
        case notification = "notification"
        case unread = "unread"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decodeIfPresent(Bool.self, forKey: .success)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        notification = try values.decodeIfPresent([Notification].self, forKey: .notification)
        unread = try values.decodeIfPresent(Int.self, forKey: .unread)
    }

}
