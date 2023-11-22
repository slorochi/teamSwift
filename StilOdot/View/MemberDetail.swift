//
//  MemberDetail.swift
//  StilOdot
//
//  Created by LANDA Théo on 22/11/2023.
//

import Foundation
import SwiftUI
import UIKit

struct MemberDetailView: View {
    @ObservedObject var teamStore: TeamStore
    let member :Team
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
            VStack{
                ZStack (alignment : .center){
                AsyncImage(url: URL(string: member.imageUrl) ?? URL(string: "https://images.pexels.com/photos/428364/pexels-photo-428364.jpeg")!) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                        //                            .aspectRatio(contentMode: .fit)
                    case .failure, .empty:
                        ProgressView()
                    @unknown default:
                        EmptyView()
                    }
                }
                    HStack{
                        Text("\(member.name) : ")
                            .font(.title2)
                            .bold()
                        Text("\(member.role)")
                            .font(.title3)
                            .bold()
                    }.position()
                    
            }
                HStack{
                    Text("Date d'arrivée : ")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Text("\(formattedDate(date: member.creationDate))")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                HStack{
                    Text("Salaire : ")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Text("\(member.salary) €")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                Form {
                    Section(header: Text("Team Details")) {
                        TextField("Image URL", text: $imageUrl)
                        TextField("Nom", text: $name)
                        TextField("Métier", text: $role)
                        Stepper(value: $rating, in: 0...10) {
                            Text("Note: \(rating, specifier: "%.0f")")
                        }
                        HStack {
                            TextField("Salaire", value: $salary, format: .number)
                            Text("€")
                        }
                        DatePicker("Date d'arrivée", selection: $creationDate, displayedComponents: .date)
                        ColorPicker("Choisir couleur", selection: $color)
                    }
                    
                    Section {
                        Button("Modifier") {
                            // Modifier les détails du membre existant
                            if let index = teamStore.members.firstIndex(where: { $0.id == member.id }) {
                                teamStore.members[index].imageUrl = imageUrl
                                teamStore.members[index].name = name
                                teamStore.members[index].role = role
                                teamStore.members[index].rating = rating
                                teamStore.members[index].salary = salary
                                teamStore.members[index].creationDate = creationDate
                                teamStore.members[index].color = color
                            }
                            showToast = true
                            toastMessage = "Membre modifié!"
                            // Réinitialiser le toast après un délai
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                showToast = false
                                toastMessage = ""
                            }
                        }
                    }
                }
                .overlay(
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
            }
            .navigationTitle("Modifier \(member.name)")
            .onAppear {
                            // Charger les détails du membre dans les State
                            imageUrl = member.imageUrl
                            name = member.name
                            role = member.role
                            rating = member.rating
                            salary = member.salary
                            creationDate = member.creationDate
                            color = member.color
                        }
        }
    }
    
    func formattedDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        return dateFormatter.string(from: date)
    }
}
