//
//  AddMemberView.swift
//  StilOdot
//
//  Created by LANDA Théo on 22/11/2023.
//

import Foundation
import SwiftUI
import UIKit

struct AddMemberView: View {
    @ObservedObject var teamStore: TeamStore
    @State private var showToast: Bool = false
    @State private var toastMessage: String = ""
    @State private var imageUrl = ""
    @State private var name = ""
    @State private var role = ""
    @State private var rating = 0
    @State private var salary = 0
    @State private var creationDate = Date()
    @State private var color = Color(.white)
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Member Details")) {
                    TextField("Image URL", text: $imageUrl)
                    TextField("Nom", text: $name)
                    TextField("Métier", text: $role)
                    Stepper(value: $rating, in: 0...10) {
                        Text("Note: \(rating, specifier: "%.0f")")
                    }
                    HStack {TextField("Salaire", value: $salary , format: .number)
                        Text("€")}
                    DatePicker("Date d'arrivée", selection: $creationDate, displayedComponents: .date)
                    ColorPicker("Choisir couleur",selection: $color)
                }.padding(8)
                
                Section {
                    
                    Button("Ajouter") {
                        let newTeam = Team(imageUrl: imageUrl, name: name, role: role, rating: rating, salary: salary, creationDate: creationDate, color: color)
                        teamStore.members.append(newTeam)
                        
                        showToast = true
                        toastMessage = "Membre ajouté à l'équipe!"
                        // Réinitialiser le toast après un délai
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                            showToast = false
                                            toastMessage = ""
                        }
                        imageUrl = ""
                        name = ""
                        role = ""
                        rating = 0
                        salary = 0
                        creationDate = Date()
                        color = Color(.white)
                    }
                }
            }.overlay(
                ZStack {
                    Spacer()
                    HStack {
                        Spacer()
                        ToastView(message: toastMessage)
                            .opacity(showToast ? 1 : 0)
                            .animation(.easeInOut(duration: 0.3))
                        Spacer()
                    }
                }            )
            .navigationTitle("Ajouter un membre")
        }
    }
}
