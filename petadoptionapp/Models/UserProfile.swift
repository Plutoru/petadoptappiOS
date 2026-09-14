//
//  UserProfile.swift
//  petadoptionapp
//
//  Created by STUDENT on 9/9/26.
//

import Foundation

struct UserProfile {
    var name: String
    var handle: String
    var location: String
    var isVerified: Bool
    var bio: String
    var postedCount: Int
    var adoptedOutCount: Int
    var savedCount: Int
    var showLocation: Bool = true
}
