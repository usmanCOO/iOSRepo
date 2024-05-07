//
//  AddSubscriptionResponse.swift
//  DealDoc
//
//  Created by Asad Khan on 1/19/23.
//

import Foundation
class AddSubscriptionResponse : Codable {
    var message : String?
    var success : Bool?
    var subscription : Subscription?

    enum CodingKeys: String, CodingKey {

        case message = "message"
        case success = "success"
        case subscription = "subscription"
    }

//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        message = try values.decodeIfPresent(String.self, forKey: .message)
//        success = try values.decodeIfPresent(Bool.self, forKey: .success)
//        subscription = try values.decodeIfPresent([Subscription].self, forKey: .subscription)
//    }

}
