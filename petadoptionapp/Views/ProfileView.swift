//
//  ProfileView.swift
//  petadoptionapp
//
//  Created by STUDENT on 9/9/26.
//

import SwiftUI

struct ProfileView: View {
    @ObservedObject var controller: AppController
    @State private var selectedTab = 0
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex: "#F9F6F0").ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 16) {
                        
                        // Header Title + Settings Gear Button
                        HStack {
                            Text("My Profile")
                                .font(.system(size: 28, weight: .bold, design: .serif))
                            Spacer()
                            NavigationLink(destination: SettingsView(controller: controller)) {
                                Image(systemName: "gearshape")
                                    .font(.title3)
                                    .padding(8)
                                    .background(Color.white)
                                    .clipShape(Circle())
                                    .foregroundColor(.black)
                            }
                        }
                        .padding(.horizontal)
                        
                        // Profile Info Card
                        VStack(spacing: 16) {
                            HStack(alignment: .top, spacing: 16) {
                                Image(systemName: "person.crop.circle.fill")
                                    .resizable()
                                    .frame(width: 70, height: 70)
                                    .foregroundColor(.orange)
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(controller.user.name)
                                        .font(.system(size: 20, weight: .bold, design: .serif))
                                    
                                    // DYNAMIC LOCATION DISCOVERY
                                    Text("\(controller.user.handle)\(controller.user.showLocation ? " • " + controller.user.location : "")")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    
                                    Text("Verified Adopter ✓")
                                        .font(.caption2)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 3)
                                        .background(Color.orange.opacity(0.15))
                                        .foregroundColor(.orange)
                                        .cornerRadius(6)
                                }
                                Spacer()
                            }
                            
                            Text(controller.user.bio)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            // Metrics Row
                            HStack {
                                MetricBox(value: "\(controller.user.postedCount)", label: "Posted")
                                Divider().frame(height: 30)
                                MetricBox(value: "\(controller.user.adoptedOutCount)", label: "Adopted Out")
                                Divider().frame(height: 30)
                                MetricBox(value: "\(controller.user.savedCount)", label: "Saved")
                            }
                            .padding(.top, 8)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(20)
                        .padding(.horizontal)
                        
                        // Segmented Tab Picker
                        HStack(spacing: 0) {
                            TabButton(title: "Posted", isSelected: selectedTab == 0) { selectedTab = 0 }
                            TabButton(title: "Adopted", isSelected: selectedTab == 1) { selectedTab = 1 }
                            TabButton(title: "Saved", isSelected: selectedTab == 2) { selectedTab = 2 }
                        }
                        .padding(4)
                        .background(Color(hex: "#EFEBE4"))
                        .cornerRadius(16)
                        .padding(.horizontal)
                        
                        // Tab Content Views
                        if selectedTab == 0 {
                            VStack(spacing: 12) {
                                ForEach(controller.pets.filter { $0.status == .active }) { pet in
                                    ProfilePetRow(pet: pet, controller: controller, showAdoptedBtn: true)
                                }
                            }
                            .padding(.horizontal)
                        } else if selectedTab == 1 {
                            VStack(spacing: 12) {
                                ForEach(controller.pets.filter { $0.status == .adopted }) { pet in
                                    ProfilePetRow(pet: pet, controller: controller, showAdoptedBtn: false)
                                }
                                
                                VStack(spacing: 8) {
                                    Image(systemName: "pawprint.fill")
                                        .foregroundColor(Color(hex: "#C8623A"))
                                    Text("5 pets found loving homes")
                                        .font(.headline)
                                    Text("Your efforts have changed lives.")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color(hex: "#EFEBE4").opacity(0.5))
                                .cornerRadius(16)
                                .padding(.top, 16)
                            }
                            .padding(.horizontal)
                        } else {
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                                ForEach(controller.pets.filter { $0.isSaved }) { pet in
                                    SavedPetGridCard(pet: pet)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(.vertical)
                }
            }
        }
    }
}
// MARK: - Reusable Components for ProfileView
struct MetricBox: View {
    let value: String
    let label: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.headline)
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

struct TabButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline.weight(.semibold))
                .foregroundColor(isSelected ? .white : .black)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(isSelected ? Color(hex: "#C8623A") : Color.white)
                .cornerRadius(12)
        }
    }
}

struct ProfilePetRow: View {
    let pet: Pet
    @ObservedObject var controller: AppController
    let showAdoptedBtn: Bool
    
    var body: some View {
        HStack(spacing: 12) {
            // Thumbnail placeholder
            Rectangle()
                .fill(Color.orange.opacity(0.2))
                .frame(width: 72, height: 72)
                .overlay(
                    Image(systemName: "photo")
                        .foregroundColor(.orange)
                )
                .clipShape(RoundedRectangle(cornerRadius: 12))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(pet.name)
                    .font(.headline)
                Text("\(pet.breed) • \(pet.age)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                HStack(spacing: 6) {
                    Image(systemName: "mappin.and.ellipse")
                    Text(pet.location)
                }
                .font(.caption)
                .foregroundColor(.secondary)
            }
            Spacer()
            
            if showAdoptedBtn && pet.status == .active {
                Button("Mark Adopted") {
                    controller.markAsAdopted(pet: pet)
                }
                .font(.caption)
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(Color.green.opacity(0.15))
                .foregroundColor(.green)
                .cornerRadius(8)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
    }
}

struct SavedPetGridCard: View {
    let pet: Pet
    
    var body: some View {
        VStack(spacing: 8) {
            Rectangle()
                .fill(Color.orange.opacity(0.2))
                .frame(height: 120)
                .overlay(
                    Image(systemName: "photo")
                        .foregroundColor(.orange)
                )
                .clipShape(RoundedRectangle(cornerRadius: 12))
            
            VStack(alignment: .leading, spacing: 2) {
                Text(pet.name)
                    .font(.subheadline.weight(.semibold))
                Text(pet.breed)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(8)
        .background(Color.white)
        .cornerRadius(14)
    }
}

