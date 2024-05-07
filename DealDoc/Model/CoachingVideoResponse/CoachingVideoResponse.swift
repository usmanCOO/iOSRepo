//
//  CoachingVideoResponse.swift
//  DealDoc
//
//  Created by Asad Khan on 11/22/22.
//


import Foundation
struct CoachingVideoResponse : Codable {
    let message : String?
    let success : Bool?
    let video_data : [VideosData]?

    enum CodingKeys: String, CodingKey {

        case message = "message"
        case success = "success"
        case video_data = "video_data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        success = try values.decodeIfPresent(Bool.self, forKey: .success)
        video_data = try values.decodeIfPresent([VideosData].self, forKey: .video_data)
    }

}
