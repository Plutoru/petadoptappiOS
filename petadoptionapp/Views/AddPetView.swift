//
//  AddPetView.swift
//  petadoptionapp
//
//  Created by STUDENT on 9/9/26.
//

import SwiftUI

struct AddPetView: View {
    @ObservedObject var controller: AppController
    @Binding var isPresented: Bool
    
    @State private var currentStep = 1
    
    // Step 1 Form Fields
    @State private var petName: String = ""
    @State private var selectedSpecies: String = "Dog"
    @State private var breed: String = ""
    @State private var selectedGender: String = "Male"
    @State private var selectedAge: String = "1–3 years"
    @State private var selectedSize: String = "Medium"
    @State private var location: String = ""
    
    // Step 2 Form Fields
    @State private var isVaccinated: Bool = false
    @State private var isSpayedNeutered: Bool = false
    @State private var isGoodWithKids: Bool = false
    @State private var isGoodWithPets: Bool = false
    
    // Step 3 Form Fields
    @State private var storyDescription: String = ""
    
    // Options Constants
    let speciesList = [
        ("🐶", "Dog"),
        ("🐱", "Cat"),
        ("🐰", "Rabbit"),
        ("🦜", "Bird"),
        ("🐾", "Other")
    ]
    
    let ageRanges = ["< 3 months", "3–12 months", "1–3 years", "3–7 years", "7+ years"]
    let sizeList = ["Small", "Medium", "Large"]
    
    var displayName: String {
        petName.trimmingCharacters(in: .whitespaces).isEmpty ? "Salmon" : petName
    }
    
    var body: some View {
        ZStack {
            Color("#F9F6F0").ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    
                    // Header Section
                    VStack(alignment: .leading, spacing: 4) {
                        Text("HELP THEM FIND A HOME")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(Color(hex: "#A89F91"))
                        
                        Text("Post a Pet")
                            .font(.system(size: 28, weight: .bold, design: .serif))
                            .foregroundColor(Color(hex: "#2C221E"))
                    }
                    .padding(.horizontal)
                    
                    // 3-Step Progress Indicator
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(spacing: 8) {
                            ForEach(1...3, id: \.self) { step in
                                Rectangle()
                                    .fill(step <= currentStep ? Color(hex: "#C8623A") : Color(hex: "#E5DEC9"))
                                    .frame(height: 4)
                                    .cornerRadius(2)
                            }
                        }
                        
                        Text(stepSubtitle)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal)
                    
                    // STEP CONTENT
                    if currentStep == 1 {
                        stepOneView
                    } else if currentStep == 2 {
                        stepTwoView
                    } else {
                        stepThreeView
                    }
                }
                .padding(.vertical)
                .padding(.bottom, 80) // Leave space for bottom bar
            }
        }
    }
    
    private var stepSubtitle: String {
        switch currentStep {
        case 1: return "Step 1 of 3 — Basic Info"
        case 2: return "Step 2 of 3 — Health & Details"
        default: return "Step 3 of 3 — Photos & Story"
        }
    }
    
    // MARK: - STEP 1: Basic Info
    private var stepOneView: some View {
        VStack(alignment: .leading, spacing: 18) {
            
            // Pet Name
            VStack(alignment: .leading, spacing: 6) {
                Text("Pet's Name")
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                TextField("e.g. Mango", text: $petName)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
            }
            
            // Species Selector
            VStack(alignment: .leading, spacing: 6) {
                Text("Species")
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(speciesList, id: \.1) { emoji, species in
                            Button(action: { selectedSpecies = species }) {
                                HStack(spacing: 6) {
                                    Text(emoji)
                                    Text(species)
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 10)
                                .background(selectedSpecies == species ? Color.white : Color.white.opacity(0.6))
                                .foregroundColor(selectedSpecies == species ? Color(hex: "#2C221E") : .secondary)
                                .cornerRadius(16)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(selectedSpecies == species ? Color(hex: "#C8623A") : Color.clear, lineWidth: 1.5)
                                )
                            }
                        }
                    }
                }
            }
            
            // Breed
            VStack(alignment: .leading, spacing: 6) {
                Text("Breed")
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                TextField("e.g. Golden Retriever, Mixed", text: $breed)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
            }
            
            // Gender
            VStack(alignment: .leading, spacing: 6) {
                Text("Gender")
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                HStack(spacing: 12) {
                    GenderButton(title: "♂ Male", isSelected: selectedGender == "Male") {
                        selectedGender = "Male"
                    }
                    GenderButton(title: "♀ Female", isSelected: selectedGender == "Female") {
                        selectedGender = "Female"
                    }
                }
            }
            
            // Age Selection Pills
            VStack(alignment: .leading, spacing: 8) {
                Text("Age")
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 8) {
                        ForEach(ageRanges.prefix(3), id: \.self) { age in
                            SelectionPill(title: age, isSelected: selectedAge == age) {
                                selectedAge = age
                            }
                        }
                    }
                    HStack(spacing: 8) {
                        ForEach(ageRanges.suffix(2), id: \.self) { age in
                            SelectionPill(title: age, isSelected: selectedAge == age) {
                                selectedAge = age
                            }
                        }
                    }
                }
            }
            
            // Size Selection Pills
            VStack(alignment: .leading, spacing: 6) {
                Text("Size")
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                HStack(spacing: 12) {
                    ForEach(sizeList, id: \.self) { size in
                        SelectionPill(title: size, isSelected: selectedSize == size) {
                            selectedSize = size
                        }
                    }
                }
            }
            
            // Location Input
            VStack(alignment: .leading, spacing: 6) {
                Text("Location")
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                TextField("City, State", text: $location)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
            }
            
            // Continue Button
            Button(action: { withAnimation { currentStep = 2 } }) {
                Text("Continue")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(hex: "#C8623A"))
                    .cornerRadius(16)
            }
            .padding(.top, 8)
        }
        .padding(.horizontal)
    }
    
    // MARK: - STEP 2: Health & Details
    private var stepTwoView: some View {
        VStack(alignment: .leading, spacing: 18) {
            
            Text("Check all that apply for \(displayName):")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            VStack(spacing: 12) {
                DetailCheckCard(
                    title: "Vaccinated",
                    subtitle: "Up to date on core vaccinations",
                    isChecked: $isVaccinated
                )
                
                DetailCheckCard(
                    title: "Spayed / Neutered",
                    subtitle: "Already spayed or neutered",
                    isChecked: $isSpayedNeutered
                )
                
                DetailCheckCard(
                    title: "Good with Kids",
                    subtitle: "Comfortable around children",
                    isChecked: $isGoodWithKids
                )
                
                DetailCheckCard(
                    title: "Good with Other Pets",
                    subtitle: "Gets along with cats, dogs, etc.",
                    isChecked: $isGoodWithPets
                )
            }
            
            // Navigation Buttons
            HStack(spacing: 12) {
                Button(action: { withAnimation { currentStep = 1 } }) {
                    Text("Back")
                        .font(.headline)
                        .foregroundColor(Color(hex: "#2C221E"))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(16)
                }
                
                Button(action: { withAnimation { currentStep = 3 } }) {
                    Text("Continue")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(hex: "#C8623A"))
                        .cornerRadius(16)
                }
            }
            .padding(.top, 16)
        }
        .padding(.horizontal)
    }
    
    // MARK: - STEP 3: Photos & Story
    private var stepThreeView: some View {
        VStack(alignment: .leading, spacing: 18) {
            
            // Photo Upload Placeholder
            VStack(alignment: .leading, spacing: 6) {
                Text("Photos")
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Button(action: {}) {
                    VStack(spacing: 6) {
                        Image(systemName: "plus")
                            .font(.title2)
                            .foregroundColor(.gray)
                        Text("Add Photo")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .frame(width: 100, height: 100)
                    .background(Color.white)
                    .cornerRadius(16)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.gray.opacity(0.4), style: StrokeStyle(lineWidth: 1, dash: [4]))
                    )
                }
                
                Text("Up to 3 photos. Tap + to add.")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            
            // Tell us about Pet
            VStack(alignment: .leading, spacing: 6) {
                Text("Tell us about \(displayName)")
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                ZStack(alignment: .topLeading) {
                    if storyDescription.isEmpty {
                        Text("Describe \(displayName)'s personality, daily routine, what they love, why you're rehoming them, and any special needs...")
                            .font(.subheadline)
                            .foregroundColor(.gray.opacity(0.7))
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                    }
                    
                    TextEditor(text: $storyDescription)
                        .font(.subheadline)
                        .frame(height: 120)
                        .padding(8)
                        .scrollContentBackground(.hidden)
                        .background(Color.white)
                        .cornerRadius(16)
                }
            }
            
            // Summary Card Preview
            VStack(alignment: .leading, spacing: 6) {
                Text("SUMMARY")
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundColor(.secondary)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(displayName)
                        .font(.system(size: 20, weight: .bold, design: .serif))
                    
                    Text("\(breed.isEmpty ? "Mixed" : breed) \(selectedSpecies) • \(selectedAge) • \(selectedSize) • \(selectedGender)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    HStack(spacing: 4) {
                        Image(systemName: "mappin.and.ellipse")
                            .font(.caption2)
                            .foregroundColor(.orange)
                        Text(location.isEmpty ? "City, State" : location)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.white)
                .cornerRadius(16)
            }
            
            // Submit Button Action Row
            HStack(spacing: 12) {
                Button(action: { withAnimation { currentStep = 2 } }) {
                    Text("Back")
                        .font(.headline)
                        .foregroundColor(Color(hex: "#2C221E"))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(16)
                }
                
                Button(action: submitPet) {
                    Text("Post Pet")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(hex: "#C8623A"))
                        .cornerRadius(16)
                }
            }
            .padding(.top, 8)
        }
        .padding(.horizontal)
    }
    
    // Save created pet into App state and dismiss back to Home
    private func submitPet() {
        var tags: [String] = []
        if isVaccinated { tags.append("Vaccinated") }
        if isSpayedNeutered { tags.append("Spayed/Neutered") }
        if isGoodWithKids { tags.append("Kid-friendly") }
        if isGoodWithPets { tags.append("Pet-friendly") }
        if tags.isEmpty { tags = ["Playful", "Trained"] }
        
        let newPet = Pet(
            name: petName.isEmpty ? "Salmon" : petName,
            breed: breed.isEmpty ? "Mixed" : breed,
            age: selectedAge,
            gender: selectedGender,
            category: selectedSpecies + "s",
            location: location.isEmpty ? "Austin, TX" : location,
            tags: tags,
            posterName: controller.user.name,
            postedTime: "Just now",
            likesCount: 0,
            imageName: "pawprint.fill",
            isSaved: false,
            status: .active
        )
        
        controller.pets.insert(newPet, at: 0)
        controller.user.postedCount += 1
        isPresented = false
    }
}

// MARK: - Helper UI Components
struct SelectionPill: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.caption)
                .fontWeight(.medium)
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(Color.white)
                .foregroundColor(isSelected ? Color(hex: "#C8623A") : Color(hex: "#2C221E"))
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(isSelected ? Color(hex: "#C8623A") : Color.clear, lineWidth: 1.5)
                )
        }
    }
}

struct GenderButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(Color.white)
                .foregroundColor(isSelected ? Color(hex: "#C8623A") : Color(hex: "#2C221E"))
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(isSelected ? Color(hex: "#C8623A") : Color.clear, lineWidth: 1.5)
                )
        }
    }
}

struct DetailCheckCard: View {
    let title: String
    let subtitle: String
    @Binding var isChecked: Bool
    
    var body: some View {
        Button(action: { isChecked.toggle() }) {
            HStack(spacing: 16) {
                Image(systemName: isChecked ? "checkmark.circle.fill" : "plus")
                    .font(.title3)
                    .foregroundColor(isChecked ? .white : Color(hex: "#8C8275"))
                    .frame(width: 36, height: 36)
                    .background(isChecked ? Color(hex: "#C8623A") : Color(hex: "#EFEAE1"))
                    .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(Color(hex: "#2C221E"))
                    
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                Spacer()
            }
            .padding()
            .background(Color.white)
            .cornerRadius(18)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
