//
//  User.swift
//  EventFinder
//
//  Created by Akhil Gudipaty on 4/29/22.
//

import Foundation
struct User  : Identifiable, Decodable, Encodable {
    var id : String
    var name : String
    var host: Bool
    var username: String
    var password: String
    var profile_pic: String
    var ratings: Float
    var numEvents: Int


    static let standard_user = User(id: "1", name: "John Doe", host: false, username: "john_doe", password: "12345", profile_pic: "standard", ratings: 0, numEvents: 0)
    static let standard_host = User(id: "2", name: "Jane Doe", host: true, username: "jane_doe", password: "12345", profile_pic: "standard", ratings: 4, numEvents: 0)
}
