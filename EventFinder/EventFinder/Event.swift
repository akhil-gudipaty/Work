//
//  Event.swift
//  EventFinder
//
//  Created by Akhil Gudipaty on 4/27/22.
//

import Foundation
struct Event  : Identifiable, Decodable, Encodable {
    let id : String
    let name : String
    let host_username: String
    let date: String
    let time : String
    let description : String
    let address : String
    var rating: Float
    var numRating: Int
    var population : Int
    let event_image: String
    static let standard = Event(id: "9", name: "Papi Chulo Prom", host_username: "jane_doe", date: "12/13/2021", time: "10:30 PM", description: "This is your chance to meet the incoming class of 2025 and be more social to meet new people", address: "232 W. Avenue", rating: 3, numRating: 10, population: 30, event_image: "standard_event")
}
