//
//  VideosData.swift
//  DealDoc
//
//  Created by Asad Khan on 11/22/22.
//

import Foundation
struct VideosData : Codable {
    let id : Int?
    let name : String?
    let metadata : String?
    let url : String?
    let thumbnail : String?
    let isArchive : Bool?
    let createdAt : String?
    let updatedAt : String?
    let video_createed_by : String?
    var isPurchased: Bool = false

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case name = "name"
        case metadata = "metadata"
        case url = "url"
        case thumbnail = "thumbnail"
        case isArchive = "isArchive"
        case createdAt = "createdAt"
        case updatedAt = "updatedAt"
        case video_createed_by = "video_createed_by"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        metadata = try values.decodeIfPresent(String.self, forKey: .metadata)
        url = try values.decodeIfPresent(String.self, forKey: .url)
        thumbnail = try values.decodeIfPresent(String.self, forKey: .thumbnail)
        isArchive = try values.decodeIfPresent(Bool.self, forKey: .isArchive)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
        video_createed_by = try values.decodeIfPresent(String.self, forKey: .video_createed_by)
    }

}
