//
//  SettingsView.swift
//  petadoptionapp
//
//  Created by STUDENT on 9/9/26.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var controller: AppController
    
    // Local notification toggle for adoption requests
    @State private var adoptionRequests = true
    
    var body: some View {
        ZStack {
            Color(hex: "#F9F6F0").ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    // Custom Back Button & Title
                    HStack(spacing: 16) {
                        Button(action: { dismiss() }) {
                            Image(systemName: "chevron.left")
                                .padding(10)
                                .background(Color.white)
                                .clipShape(Circle())
                                .foregroundColor(.black)
                        }
                        Text("Settings")
                            .font(.system(size: 24, weight: .bold, design: .serif))
                    }
                    .padding(.horizontal)
                    
                    // ACCOUNT SECTION
                    SectionHeader(title: "ACCOUNT")
                    VStack(spacing: 12) {
                        NavigationLink(destination: EditProfileView(controller: controller)) {
                            SettingsRow(icon: "person", title: "Edit Profile", subtitle: "Update your name, photo, and bio", iconBg: .orange.opacity(0.15))
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        NavigationLink(destination: ChangePasswordView()) {
                            SettingsRow(icon: "lock", title: "Change Password", subtitle: "Update your login credentials", iconBg: .green.opacity(0.15))
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    .padding(.horizontal)
                    
                    // NOTIFICATIONS SECTION
                    SectionHeader(title: "NOTIFICATIONS")
                    VStack(spacing: 12) {
                        ToggleRow(title: "Adoption Requests", subtitle: "When someone requests your pet", isOn: $adoptionRequests)
                        ToggleRow(title: "Pet Updates", subtitle: "Status changes on pets you've saved", isOn: $controller.petUpdatesEnabled)
                    }
                    .padding(.horizontal)
                    
                    // PRIVACY SECTION
                    SectionHeader(title: "PRIVACY")
                    VStack(spacing: 12) {
                        ToggleRow(title: "Show Location", subtitle: "Display city on your public profile", isOn: $controller.user.showLocation)
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

// MARK: - Reusable UI Components
struct SectionHeader: View {
    let title: String
    var body: some View {
        Text(title)
            .font(.caption)
            .fontWeight(.bold)
            .foregroundColor(.secondary)
            .padding(.horizontal)
    }
}

struct SettingsRow: View {
    let icon: String
    let title: String
    let subtitle: String
    let iconBg: Color
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .frame(width: 36, height: 36)
                .background(iconBg)
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title).font(.subheadline).bold()
                Text(subtitle).font(.caption).foregroundColor(.secondary)
            }
            Spacer()
            Image(systemName: "chevron.right").font(.caption).foregroundColor(.gray)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
    }
}

struct ToggleRow: View {
    let title: String
    let subtitle: String
    @Binding var isOn: Bool
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(title).font(.subheadline).bold()
                Text(subtitle).font(.caption).foregroundColor(.secondary)
            }
            Spacer()
            Toggle("", isOn: $isOn)
                .tint(Color(hex: "#C8623A"))
                .labelsHidden()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
    }
}

// MARK: - Edit Profile View
struct EditProfileView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var controller: AppController
    
    @State private var name: String = ""
    @State private var location: String = ""
    @State private var bio: String = ""
    @State private var showSavedAlert = false
    
    var body: some View {
        ZStack {
            Color(hex: "#F9F6F0").ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 20) {
                HStack(spacing: 16) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .padding(10)
                            .background(Color.white)
                            .clipShape(Circle())
                            .foregroundColor(.black)
                    }
                    Text("Edit Profile")
                        .font(.system(size: 24, weight: .bold, design: .serif))
                }
                .padding(.horizontal)
                
                VStack(spacing: 16) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Full Name").font(.caption).bold().foregroundColor(.secondary)
                        TextField("Name", text: $name)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                    }
                    
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Location").font(.caption).bold().foregroundColor(.secondary)
                        TextField("Location", text: $location)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                    }
                    
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Bio").font(.caption).bold().foregroundColor(.secondary)
                        TextEditor(text: $bio)
                            .frame(height: 100)
                            .padding(8)
                            .background(Color.white)
                            .cornerRadius(12)
                    }
                    
                    Button(action: saveChanges) {
                        Text("Save Changes")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(hex: "#C8623A"))
                            .cornerRadius(14)
                    }
                    .padding(.top, 10)
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .padding(.vertical)
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            name = controller.user.name
            location = controller.user.location
            bio = controller.user.bio
        }
        .alert("Profile Updated", isPresented: $showSavedAlert) {
            Button("OK", role: .cancel) { dismiss() }
        } message: {
            Text("Your profile information has been saved successfully.")
        }
    }
    
    private func saveChanges() {
        controller.updateProfile(name: name, bio: bio, location: location)
        showSavedAlert = true
    }
}

// MARK: - Change Password View
struct ChangePasswordView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var currentPassword = ""
    @State private var newPassword = ""
    @State private var confirmPassword = ""
    @State private var alertMessage = ""
    @State private var showAlert = false
    
    var body: some View {
        ZStack {
            Color(hex: "#F9F6F0").ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 20) {
                HStack(spacing: 16) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .padding(10)
                            .background(Color.white)
                            .clipShape(Circle())
                            .foregroundColor(.black)
                    }
                    Text("Change Password")
                        .font(.system(size: 24, weight: .bold, design: .serif))
                }
                .padding(.horizontal)
                
                VStack(spacing: 16) {
                    SecureField("Current Password", text: $currentPassword)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                    
                    SecureField("New Password", text: $newPassword)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                    
                    SecureField("Confirm New Password", text: $confirmPassword)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                    
                    Button(action: updatePassword) {
                        Text("Update Password")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(hex: "#C8623A"))
                            .cornerRadius(14)
                    }
                    .padding(.top, 10)
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .padding(.vertical)
        }
        .navigationBarBackButtonHidden(true)
        .alert("Notice", isPresented: $showAlert) {
            Button("OK", role: .cancel) {
                if alertMessage == "Password updated successfully!" {
                    dismiss()
                }
            }
        } message: {
            Text(alertMessage)
        }
    }
    
    private func updatePassword() {
        guard !currentPassword.isEmpty, !newPassword.isEmpty, !confirmPassword.isEmpty else {
            alertMessage = "Please fill in all password fields."
            showAlert = true
            return
        }
        
        guard newPassword == confirmPassword else {
            alertMessage = "New passwords do not match."
            showAlert = true
            return
        }
        
        alertMessage = "Password updated successfully!"
        showAlert = true
    }
}
