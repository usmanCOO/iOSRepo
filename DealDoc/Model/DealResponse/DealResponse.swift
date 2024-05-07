//
//  DealResponse.swift
//  DealDoc
//
//  Created by Asad Khan on 9/22/22.
//


import Foundation
struct DealResponse : Codable {
    let deal_data : [Deal_data]?
    let success : Bool?
    let message : String?
   
    enum CodingKeys: String, CodingKey {

        case deal_data = "deal_data"
        case success = "success"
        case message = "message"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        deal_data = try values.decodeIfPresent([Deal_data].self, forKey: .deal_data)
        success = try values.decodeIfPresent(Bool.self, forKey: .success)
        message = try values.decodeIfPresent(String.self, forKey: .message)
    }

}


struct UserDealResponse : Codable {
    let deal_data : [Deal_data]?
    let success : Bool?
    let message : String?
   
    enum CodingKeys: String, CodingKey {

        case deal_data = "deal"
        case success = "success"
        case message = "message"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        deal_data = try values.decodeIfPresent([Deal_data].self, forKey: .deal_data)
        success = try values.decodeIfPresent(Bool.self, forKey: .success)
        message = try values.decodeIfPresent(String.self, forKey: .message)
    }

}


struct GetDealStatus : Codable {
    
    var success: Bool?
    var message: String?
}
