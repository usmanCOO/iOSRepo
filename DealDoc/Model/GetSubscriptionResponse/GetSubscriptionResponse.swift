//
//  GetSubscriptionResponse.swift
//  DealDoc
//
//  Created by Asad Khan on 1/19/23.
//


import Foundation
class GetSubscriptionResponse : Codable {
    var message : String?
    var success : Bool?
    var subscriptionended : Bool?
    var subscription : [Subscription]?

    enum CodingKeys: String, CodingKey {

        case message = "message"
        case success = "success"
        case subscriptionended = "subscriptionended"
        case subscription = "subscription"
    }

//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        message = try values.decodeIfPresent(String.self, forKey: .message)
//        success = try values.decodeIfPresent(Bool.self, forKey: .success)
//        subscriptionended = try values.decodeIfPresent(Bool.self, forKey: .subscriptionended)
//        subscription = try values.decodeIfPresent([Subscription].self, forKey: .subscription)
//    }

}
