//
//  AppController.swift
//  petadoptionapp
//
//  Created by STUDENT on 9/9/26.
//

import Foundation
import Combine

class AppController: ObservableObject {
    @Published var pets: [Pet] = []
    @Published var user: UserProfile
    @Published var selectedCategory: String = "All"
    @Published var petUpdatesEnabled: Bool = false
    
    let categories = ["All", "Dogs", "Cats", "Rabbits", "Other"]
    
    init() {
        self.user = UserProfile(
            name: "James Rivera",
            handle: "@jamesrivera",
            location: "Austin, TX",
            isVerified: true,
            bio: "Animal lover & foster parent. I've rehomed 5 pets to wonderful families. Ask me anything about the adoption process! 🐾🐾",
            postedCount: 2,
            adoptedOutCount: 5,
            savedCount: 12,
            showLocation: true
        )
        loadSamplePets()
    }
    
    private func loadSamplePets() {
        self.pets = [
            Pet(
                name: "Mango",
                breed: "Golden Retriever",
                age: "8 months",
                gender: "Male",
                category: "Dogs",
                location: "San Francisco, CA",
                tags: ["Playful", "Trained", "Kid-friendly"],
                posterName: "Sarah Chen",
                postedTime: "2 hours ago",
                likesCount: 34,
                imageName: "dog_mango",
                isSaved: true,
                status: .active
            ),
            Pet(
                name: "Luna",
                breed: "Domestic Shorthair",
                age: "2 years",
                gender: "Female",
                category: "Cats",
                location: "Austin, TX",
                tags: ["Indoor", "Calm"],
                posterName: "James Rivera",
                postedTime: "1 day ago",
                likesCount: 18,
                imageName: "cat_luna",
                isSaved: true,
                status: .active
            ),
            Pet(
                name: "Biscuit",
                breed: "Holland Lop",
                age: "1 year",
                gender: "Male",
                category: "Rabbits",
                location: "Portland, OR",
                tags: ["Friendly"],
                posterName: "Alex M.",
                postedTime: "3 days ago",
                likesCount: 42,
                imageName: "rabbit_biscuit",
                isSaved: false,
                status: .adopted
            )
        ]
    }
    
    func toggleSave(for pet: Pet) {
        if let index = pets.firstIndex(where: { $0.id == pet.id }) {
            pets[index].isSaved.toggle()
        }
    }
    
    func markAsAdopted(pet: Pet) {
        if let index = pets.firstIndex(where: { $0.id == pet.id }) {
            pets[index].status = .adopted
        }
    }
    
    func updateProfile(name: String, bio: String, location: String) {
        user.name = name
        user.bio = bio
        user.location = location
    }
}
