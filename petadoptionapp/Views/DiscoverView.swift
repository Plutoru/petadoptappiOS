//
//  DiscoverView.swift
//  petadoptionapp
//
//  Created by STUDENT on 9/9/26.
//

import SwiftUI

struct DiscoverView: View {
    @ObservedObject var controller: AppController
    @State private var searchText = ""
    
    var filteredPets: [Pet] {
        controller.pets.filter { pet in
            let matchesCategory = controller.selectedCategory == "All" ||
                                  pet.category.lowercased() == controller.selectedCategory.lowercased()
            
            if searchText.isEmpty {
                return matchesCategory
            } else {
                let query = searchText.lowercased()
                let matchesSearch = pet.name.lowercased().contains(query) ||
                                    pet.breed.lowercased().contains(query) ||
                                    pet.location.lowercased().contains(query)
                return matchesCategory && matchesSearch
            }
        }
    }
    
    var body: some View {
        ZStack {
            Color(hex: "#F9F6F0").ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    
                    // Header Section
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("FIND A FRIEND")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(.secondary)
                            
                            Text("Pets Near You")
                                .font(.system(size: 28, weight: .bold, design: .serif))
                        }
                        Spacer()
                        
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.orange)
                    }
                    .padding(.horizontal)
                    
                    // Search Bar
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        TextField("Search by name, breed, city...", text: $searchText)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                        
                        if !searchText.isEmpty {
                            Button(action: { searchText = "" }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(16)
                    .padding(.horizontal)
                    
                    // Category Selection Pills
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(controller.categories, id: \.self) { category in
                                Button(action: { controller.selectedCategory = category }) {
                                    Text(category)
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                        .padding(.horizontal, 20)
                                        .padding(.vertical, 10)
                                        .background(controller.selectedCategory == category ? Color(hex: "#C8623A") : Color.white)
                                        .foregroundColor(controller.selectedCategory == category ? .white : .black)
                                        .cornerRadius(20)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    Text("\(filteredPets.count) pets available")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.horizontal)
                    
                    // Cards Feed
                    VStack(spacing: 20) {
                        if filteredPets.isEmpty {
                            VStack(spacing: 8) {
                                Image(systemName: "pawprint.fill")
                                    .font(.largeTitle)
                                    .foregroundColor(.gray.opacity(0.4))
                                Text("No pets found matching your criteria.")
                                    .font(.headline)
                                    .foregroundColor(.secondary)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.top, 40)
                        } else {
                            ForEach(filteredPets) { pet in
                                NavigationLink(destination: PetDetailView(pet: pet, controller: controller)) {
                                    DiscoverPetCard(pet: pet, controller: controller)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
                .padding(.bottom, 90) // Clears bottom tab bar overlap
            }
        }
    }
}

// Subview specifically used inside DiscoverView
struct DiscoverPetCard: View {
    let pet: Pet
    @ObservedObject var controller: AppController
    @State private var showSavedAlert = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            // Image Header Container
            ZStack(alignment: .topTrailing) {
                Rectangle()
                    .fill(Color.orange.opacity(0.15))
                    .frame(height: 220)
                    .overlay(
                        Image(systemName: "pawprint.circle.fill")
                            .font(.system(size: 60))
                            .foregroundColor(Color(hex: "#C8623A").opacity(0.6))
                    )
                
                // Animal Category Tag
                VStack {
                    Spacer()
                    HStack {
                        Text(pet.category.hasSuffix("s") ? String(pet.category.dropLast()) : pet.category)
                            .font(.caption)
                            .bold()
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.white)
                            .cornerRadius(12)
                        Spacer()
                    }
                    .padding(12)
                }
                
                // Favorite Button
                Button(action: {
                    let wasSaved = pet.isSaved
                    controller.toggleSave(for: pet)
                    
                    // If Pet Updates toggle is enabled and pet is being newly saved, trigger alert
                    if controller.petUpdatesEnabled && !wasSaved {
                        showSavedAlert = true
                    }
                }) {
                    Image(systemName: pet.isSaved ? "heart.fill" : "heart")
                        .foregroundColor(pet.isSaved ? Color(hex: "#C8623A") : .gray)
                        .padding(10)
                        .background(Color.white)
                        .clipShape(Circle())
                }
                .padding(12)
            }
            .clipShape(CustomCorners(corners: [.topLeft, .topRight], radius: 20))
            
            // Card Content Body
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text(pet.name)
                        .font(.system(size: 22, weight: .bold, design: .serif))
                    Spacer()
                    Text(pet.gender)
                        .font(.caption)
                        .bold()
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(Color.teal.opacity(0.12))
                        .foregroundColor(.teal)
                        .cornerRadius(10)
                }
                
                Text("\(pet.breed) • \(pet.age)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                HStack(spacing: 4) {
                    Image(systemName: "mappin.and.ellipse")
                    Text(pet.location)
                }
                .font(.caption)
                .foregroundColor(.secondary)
                
                // Tags
                HStack(spacing: 8) {
                    ForEach(pet.tags, id: \.self) { tag in
                        Text(tag)
                            .font(.caption2)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(Color(hex: "#F3EFEA"))
                            .cornerRadius(8)
                    }
                }
                
                Divider().padding(.vertical, 4)
                
                // Card Footer
                HStack {
                    Image(systemName: "person.circle.fill")
                        .foregroundColor(.gray)
                    Text("\(pet.posterName) • \(pet.postedTime)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Spacer()
                    HStack(spacing: 4) {
                        Image(systemName: "heart.fill")
                            .foregroundColor(Color(hex: "#C8623A"))
                        Text("\(pet.likesCount)")
                    }
                    .font(.caption)
                }
            }
            .padding(16)
            .background(Color.white)
            .clipShape(CustomCorners(corners: [.bottomLeft, .bottomRight], radius: 20))
        }
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
        .alert("Notification", isPresented: $showSavedAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Saved successfully")
        }
    }
}
