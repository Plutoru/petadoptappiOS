//
//  PetDetailView.swift
//  petadoptionapp
//
//  Created by STUDENT on 9/11/26.
//

import SwiftUI

struct PetDetailView: View {
    let pet: Pet
    @ObservedObject var controller: AppController
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack(alignment: .bottom) {
            Color(hex: "#F9F6F0").ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 16) {
                    
                    // Image Header
                    ZStack(alignment: .topLeading) {
                        Rectangle()
                            .fill(Color.orange.opacity(0.2))
                            .frame(height: 300)
                            .overlay(
                                Image(systemName: "pawprint.circle.fill")
                                    .font(.system(size: 80))
                                    .foregroundColor(Color(hex: "#C8623A").opacity(0.6))
                            )
                        
                        Button(action: { dismiss() }) {
                            Image(systemName: "chevron.left")
                                .bold()
                                .foregroundColor(.black)
                                .padding(12)
                                .background(Color.white)
                                .clipShape(Circle())
                        }
                        .padding(.top, 50)
                        .padding(.leading, 16)
                    }
                    
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text(pet.name)
                                .font(.system(size: 32, weight: .bold, design: .serif))
                            Spacer()
                            Text(pet.gender)
                                .font(.callout)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color.teal.opacity(0.12))
                                .foregroundColor(.teal)
                                .cornerRadius(12)
                        }
                        
                        Text("\(pet.breed) • \(pet.age)")
                            .font(.title3)
                            .foregroundColor(.secondary)
                        
                        HStack {
                            Image(systemName: "mappin.and.ellipse")
                            Text(pet.location)
                        }
                        .foregroundColor(.secondary)
                        
                        Divider().padding(.vertical, 8)
                        
                        Text("About Me")
                            .font(.headline)
                        
                        Text("\(pet.name) is looking for a loving home! Super friendly, loves long walks, and gets along well with people and other pets.")
                            .foregroundColor(.secondary)
                            .lineSpacing(4)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 100)
                }
            }
            
            // Fixed Bottom Action Bar
            HStack {
                Button(action: { controller.toggleSave(for: pet) }) {
                    Image(systemName: pet.isSaved ? "heart.fill" : "heart")
                        .font(.title2)
                        .foregroundColor(pet.isSaved ? Color(hex: "#C8623A") : .gray)
                        .frame(width: 50, height: 50)
                        .background(Color(hex: "#F3EFEA"))
                        .cornerRadius(14)
                }
                
                Button(action: {}) {
                    Text("Adopt \(pet.name)")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color(hex: "#C8623A"))
                        .cornerRadius(14)
                }
            }
            .padding()
            .background(Color.white.ignoresSafeArea(edges: .bottom))
        }
        .navigationBarBackButtonHidden(true)
    }
}
