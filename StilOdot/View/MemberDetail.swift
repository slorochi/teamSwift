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
    let jobOptions = ["Développeur", "Commercial", "Comptable", "Manager"]
    @State private var selectedJob = "Développeur"
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
            VStack{
                ZStack (alignment: .bottom){
                    AsyncImage(url: URL(string: member.imageUrl) ?? URL(string: "https://images.pexels.com/photos/428364/pexels-photo-428364.jpeg")!) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                            //                            .aspectRatio(contentMode: .fit)
                        case .failure, .empty:
                            Rectangle().scaledToFill().background(Color(.gray))
//                            ProgressView()
                        @unknown default:
                            EmptyView()
                        }
                    }
                    Text("\(member.name) : \(member.role)")
                           .font(.title)
                           .fontWeight(.bold)
                           .foregroundColor(.white)
                           .padding()
                        
                    }
                
                HStack{
                    Text("Salaire : ")
                        .font(.system(size:12))
                        .foregroundColor(.black)
                    Text("\(member.salary) €")
                        .font(.subheadline)
                        .foregroundColor(.black)
                }
                HStack{
                    Text("Date d'arrivée : ")
                    Text("\(formattedDate(date: member.creationDate))")
                }
                .font(.system(size: 12))
                .foregroundColor(.gray)
               
                Form {
                    Section(header: Text("Team Details")) {
                        TextField("Image URL", text: $imageUrl)
                        TextField("Nom", text: $name)
                        Picker("Métier", selection: $selectedJob) {
                            ForEach(jobOptions, id: \.self) { job in
                                Text(job)
                            }
                        }
                        Stepper(value: $rating, in: 0...10) {
                            Text("Note: \(rating)")
                        }
                        HStack {TextField("Salaire", value: $salary , format: .number) .keyboardType(.numberPad)
                            Text("€")}
                        DatePicker("Date d'arrivée", selection: $creationDate, displayedComponents: .date)
                        ColorPicker("Choisir couleur", selection: $color)
                    }
                    
                    Section {
                        Button("Modifier") {
                            // Modifier les détails du membre existant
                            if let index = teamStore.members.firstIndex(where: { $0.id == member.id }) {
                                teamStore.members[index].imageUrl = imageUrl
                                teamStore.members[index].name = name
                                teamStore.members[index].role = selectedJob
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
                            selectedJob = member.role
                            rating = member.rating
                            salary = member.salary
                            creationDate = member.creationDate
                            color = member.color
            }
        }
    
    func formattedDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        return dateFormatter.string(from: date)
    }
}
