//
//  DealData.swift
//  DealDoc
//
//  Created by Asad Khan on 9/16/22.
//


import Foundation
struct DealData : Codable {
    let is_draft : Bool?
    let is_video_purchased : Bool?
    let in_review : Bool?
    let is_session_purchased : Bool?
    let id : Int?
    let deal_name : String?
    let deal_created_by : Int?
    let updatedAt : String?
    let createdAt : String?
    

    enum CodingKeys: String, CodingKey {

        case is_draft = "is_draft"
        case is_video_purchased = "is_video_purchased"
        case in_review = "in_review"
        case is_session_purchased = "is_session_purchased"
        case id = "id"
        case deal_name = "deal_name"
        case deal_created_by = "deal_created_by"
        case updatedAt = "updatedAt"
        case createdAt = "createdAt"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        is_draft = try values.decodeIfPresent(Bool.self, forKey: .is_draft)
        is_video_purchased = try values.decodeIfPresent(Bool.self, forKey: .is_video_purchased)
        in_review = try values.decodeIfPresent(Bool.self, forKey: .in_review)
        is_session_purchased = try values.decodeIfPresent(Bool.self, forKey: .is_session_purchased)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        deal_name = try values.decodeIfPresent(String.self, forKey: .deal_name)
        deal_created_by = try values.decodeIfPresent(Int.self, forKey: .deal_created_by)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
    }

}
