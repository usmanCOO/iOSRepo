//
//  metaData.swift
//  DealDoc
//
//  Created by Asad Khan on 12/2/22.
//

import Foundation
struct metaData : Codable {
    let uri : String?
    let name : String?
    let status : String?
    let end_time : String?
  //  let location : Location?
    let created_at : String?
    let event_type : String?
    let start_time : String?
    let updated_at : String?
    let event_guests : [String]?
//    let calendar_event : Calendar_event?
//    let invitees_counter : Invitees_counter?
//    let event_memberships : [Event_memberships]?

    enum CodingKeys: String, CodingKey {

        case uri = "uri"
        case name = "name"
        case status = "status"
        case end_time = "end_time"
       // case location = "location"
        case created_at = "created_at"
        case event_type = "event_type"
        case start_time = "start_time"
        case updated_at = "updated_at"
        case event_guests = "event_guests"
//        case calendar_event = "calendar_event"
//        case invitees_counter = "invitees_counter"
//        case event_memberships = "event_memberships"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        uri = try values.decodeIfPresent(String.self, forKey: .uri)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        end_time = try values.decodeIfPresent(String.self, forKey: .end_time)
       // location = try values.decodeIfPresent(Location.self, forKey: .location)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        event_type = try values.decodeIfPresent(String.self, forKey: .event_type)
        start_time = try values.decodeIfPresent(String.self, forKey: .start_time)
        updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
        event_guests = try values.decodeIfPresent([String].self, forKey: .event_guests)
//        calendar_event = try values.decodeIfPresent(Calendar_event.self, forKey: .calendar_event)
//        invitees_counter = try values.decodeIfPresent(Invitees_counter.self, forKey: .invitees_counter)
//        event_memberships = try values.decodeIfPresent([Event_memberships].self, forKey: .event_memberships)
    }

}
