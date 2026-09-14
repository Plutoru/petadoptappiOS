//
//  MainTabView.swift
//  petadoptionapp
//
//  Created by STUDENT on 9/9/26.
//

import SwiftUI

struct MainTabView: View {
    @StateObject private var controller = AppController()
    @State private var selectedTab = 0 // 0: Discover, 1: Profile
    @State private var showAddPetSheet = false
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                // Tab Content Switcher
                Group {
                    if selectedTab == 0 {
                        DiscoverView(controller: controller)
                    } else {
                        ProfileView(controller: controller)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                // Custom Bottom Floating Navigation Bar
                HStack {
                    Spacer()
                    
                    // Discover Tab Button
                    Button(action: { selectedTab = 0 }) {
                        VStack(spacing: 4) {
                            Image(systemName: "house.fill")
                                .font(.system(size: 20))
                            Text("Discover")
                                .font(.caption2)
                        }
                        .foregroundColor(selectedTab == 0 ? Color(hex: "#C8623A") : .gray)
                    }
                    
                    Spacer()
                    
                    // Center Floating "Post Pet" Action Button
                    Button(action: { showAddPetSheet = true }) {
                        Image(systemName: "plus")
                            .font(.title2.bold())
                            .foregroundColor(.white)
                            .frame(width: 56, height: 56)
                            .background(Color(hex: "#C8623A"))
                            .clipShape(RoundedRectangle(cornerRadius: 18))
                            .shadow(color: Color(hex: "#C8623A").opacity(0.35), radius: 8, x: 0, y: 4)
                    }
                    .offset(y: -14)
                    
                    Spacer()
                    
                    // Profile Tab Button
                    Button(action: { selectedTab = 1 }) {
                        VStack(spacing: 4) {
                            Image(systemName: "person.fill")
                                .font(.system(size: 20))
                            Text("Profile")
                                .font(.caption2)
                        }
                        .foregroundColor(selectedTab == 1 ? Color(hex: "#C8623A") : .gray)
                    }
                    
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 8)
                .padding(.bottom, 12)
                .background(
                    Color.white
                        .shadow(color: Color.black.opacity(0.08), radius: 10, x: 0, y: -4)
                        .ignoresSafeArea(edges: .bottom)
                )
            }
            .ignoresSafeArea(.keyboard)
            .sheet(isPresented: $showAddPetSheet) {
                AddPetView(controller: controller, isPresented: $showAddPetSheet)
            }
        }
    }
}
