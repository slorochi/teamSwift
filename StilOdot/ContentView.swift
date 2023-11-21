//
//  ContentView.swift
//  StilOdot
//
//  Created by LANDA Théo on 20/11/2023.
//


import SwiftUI
import UIKit

struct Team:Identifiable {
    let id = UUID()
    let imageUrl: String
    let name: String
    let role: String
    let rating: Int
    let salary: Int
    let creationDate: Date
    let color: Color
}

class TeamStore: ObservableObject {
    @Published var members: [Team] = []
    
    func addMember(imageUrl: String, name: String, role: String, rating: Int,salary:Int, creationDate: Date, color: Color) {
        let newTeam = Team(imageUrl: imageUrl, name: name, role: role, rating: rating, salary: salary, creationDate: creationDate, color: color)
        members.append(newTeam)
    }
}

struct ContentView: View {
    @ObservedObject var teamStore = TeamStore()
    @State private var isShowingAddTeamView = false
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text("Votre team")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .bold()
                    // Couleur du texte du titre
                    Spacer() // Pour pousser le bouton "+" vers la droite
                    Button(action: {
                        isShowingAddTeamView.toggle()
                    }) {
                        Image(systemName: "plus")
                            .foregroundColor(.indigo)
                            .font(.title3)
                            .bold()// Couleur de l'icône du bouton "+"
                    }
                    .padding([.vertical],7)
                    .padding([.horizontal],16)
                    .background(Color.white.opacity(1)) // Couleur de fond du bouton "+"
                    .cornerRadius(8) // Coins arrondis du bouton "+"
                }
                .padding() // Ajout de marges pour espacer du bord de l'écran
                List {
                    ForEach(teamStore.members) { member in
                        HStack() {
                            AsyncImage(url: member.imageUrl != "" ? URL(string: member.imageUrl)! : URL(string: "https://images.pexels.com/photos/428364/pexels-photo-428364.jpeg")!) { phase in
                                switch phase {
                                case .success(let image):
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                case .failure, .empty:
                                    // En cas d'échec ou si l'image est vide
                                    ProgressView()
                                @unknown default:
                                    EmptyView()
                                }
                            }
                            .frame(width: 120, height: 120)
                            Spacer()
                            
                            VStack(alignment: .leading) {
                                Text(member.name)
                                    .font(.headline)
                                    .foregroundColor(.gray)
                                HStack(){
                                    Text("Salaire: ")
                                        .font(.subheadline)
                                    Text("\(member.salary)€")
                                        .font(.subheadline)
                                        .bold()
                                }
                            }
                                Text(member.role)
                                    .font(.subheadline)
                                
                                Spacer()
                                
                                VStack(alignment: .trailing, spacing: 4) {
                                    Text("Note: \(member.rating)/10")
                                        .font(.subheadline)
                                    Text("Arrivé(e) le: \(formattedDate(date: member.creationDate))")
                                        .font(.subheadline)
                                }
                            }
                           
                            .background(member.color)
                            .cornerRadius(8)
                    }
                }
                
                .sheet(isPresented: $isShowingAddTeamView) {
                    AddMemberView(teamStore: teamStore)
                }.background(Color.indigo.opacity(1))
                .padding()
            } .background(Color.indigo.opacity(1))
            } .background(Color.indigo.opacity(1))
    }
    
    func formattedDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter.string(from: date)
    }
}

struct AddMemberView: View {
    @ObservedObject var teamStore: TeamStore
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
                Section(header: Text("Team Details")) {
                    TextField("Image URL", text: $imageUrl)
                    TextField("Nom", text: $name)
                    TextField("Role", text: $role)
                    Stepper(value: $rating, in: 0...10) {
                        Text("Note: \(rating, specifier: "%.0f")")
                    }
                    HStack {TextField("Salaire", value: $salary , format: .number)
                        Text("€")}
                    DatePicker("Date d'arrivée", selection: $creationDate, displayedComponents: .date)
                    ColorPicker("Choisir couleur",selection: $color)
                }
                
                Section {
                    Button("Ajouter") {
                        let newTeam = Team(imageUrl: imageUrl, name: name, role: role, rating: rating, salary: salary, creationDate: creationDate, color: color)
                        teamStore.members.append(newTeam)
                        
                    }
                }
            }
            .navigationTitle("Ajouter un membre")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
