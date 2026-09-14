//
//  Pet.swift
//  petadoptionapp
//
//  Created by STUDENT on 9/9/26.
//

import Foundation

enum PetStatus: String, CaseIterable, Identifiable {
    case active = "Active"
    case adopted = "Adopted"
    
    var id: String { rawValue }
}

struct Pet: Identifiable, Hashable {
    let id: UUID = UUID()
    let name: String
    let breed: String
    let age: String
    let gender: String
    let category: String // Dog, Cat, Rabbit, etc.
    let location: String
    let tags: [String]
    let posterName: String
    let postedTime: String
    let likesCount: Int
    let imageName: String
    var isSaved: Bool = false
    var status: PetStatus = .active
}
