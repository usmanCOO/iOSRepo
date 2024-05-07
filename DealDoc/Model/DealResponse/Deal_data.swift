//
//  Deal_data.swift
//  DealDoc
//
//  Created by Asad Khan on 9/22/22.
//


import Foundation
struct Deal_data : Codable {
    let id : Int?
    let deal_name : String?
    let metadata  : metaData?
    let session_url : String?
    let session_start_date : String?
    let is_draft : Bool?
    let is_video_purchased : Bool?
    let in_review : Bool?
    let is_session_purchased : Bool?
    let status : String?
    let color : String?
    let investment_size : Int?
    let closed_date : String?
    let createdAt : String?
    let updatedAt : String?
    let deal_created_by : Int?
    let is_video_recommended : String?
    let payement_Id : String?
    let user : userData?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case deal_name = "deal_name"
        case metadata = "metadata"
        case session_url = "session_url"
        case session_start_date = "session_start_date"
        case is_draft = "is_draft"
        case is_video_purchased = "is_video_purchased"
        case in_review = "in_review"
        case is_session_purchased = "is_session_purchased"
        case status = "status"
        case color = "color"
        case investment_size = "investment_size"
        case closed_date = "closed_date"
        case createdAt = "createdAt"
        case updatedAt = "updatedAt"
        case deal_created_by = "deal_created_by"
        case is_video_recommended = "is_video_recommended"
        case payement_Id = "payement_Id"
        case user = "User"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        deal_name = try values.decodeIfPresent(String.self, forKey: .deal_name)
        metadata = try values.decodeIfPresent(metaData.self, forKey: .metadata)
        session_url = try values.decodeIfPresent(String.self, forKey: .session_url)
        session_start_date = try values.decodeIfPresent(String.self, forKey: .session_start_date)
        is_draft = try values.decodeIfPresent(Bool.self, forKey: .is_draft)
        is_video_purchased = try values.decodeIfPresent(Bool.self, forKey: .is_video_purchased)
        in_review = try values.decodeIfPresent(Bool.self, forKey: .in_review)
        is_session_purchased = try values.decodeIfPresent(Bool.self, forKey: .is_session_purchased)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        color = try values.decodeIfPresent(String.self, forKey: .color)
        investment_size = try values.decodeIfPresent(Int.self, forKey: .investment_size)
        closed_date = try values.decodeIfPresent(String.self, forKey: .closed_date)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
        deal_created_by = try values.decodeIfPresent(Int.self, forKey: .deal_created_by)
        is_video_recommended = try values.decodeIfPresent(String.self, forKey: .is_video_recommended)
        payement_Id = try values.decodeIfPresent(String.self, forKey: .payement_Id)
        user = try values.decodeIfPresent(userData.self, forKey: .user)
    }

}
