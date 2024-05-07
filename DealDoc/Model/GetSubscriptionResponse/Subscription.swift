//
//  Subscription.swift
//  DealDoc
//
//  Created by Asad Khan on 1/19/23.
//


import Foundation
struct Subscription : Codable {
    let id : Int?
    let duration : String?
    let startdate : String?
    let enddate : String?
    let status : Bool?
    let metadata : String?
    let createdAt : String?
    let updatedAt : String?
    let userId : Int?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case duration = "duration"
        case startdate = "startdate"
        case enddate = "enddate"
        case status = "status"
        case metadata = "metadata"
        case createdAt = "createdAt"
        case updatedAt = "updatedAt"
        case userId = "userId"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        duration = try values.decodeIfPresent(String.self, forKey: .duration)
        startdate = try values.decodeIfPresent(String.self, forKey: .startdate)
        enddate = try values.decodeIfPresent(String.self, forKey: .enddate)
        status = try values.decodeIfPresent(Bool.self, forKey: .status)
        metadata = try values.decodeIfPresent(String.self, forKey: .metadata)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
        userId = try values.decodeIfPresent(Int.self, forKey: .userId)
    }

}
