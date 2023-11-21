//
//  ContentView.swift
//  StilOdot
//
//  Created by LANDA Théo on 20/11/2023.
//


import SwiftUI
import UIKit

struct Team:Identifiable {
    var id = UUID()
    var imageUrl: String
    var name: String
    var role: String
    var rating: Int
    var salary: Int
    var creationDate: Date
    var color: Color
}

class TeamStore: ObservableObject {
    @Published var members: [Team] = []
    
    func addMember(imageUrl: String, name: String, role: String, rating: Int,salary:Int, creationDate: Date, color: Color) {
        let newTeam = Team(imageUrl: imageUrl, name: name, role: role, rating: rating, salary: salary, creationDate: creationDate, color: color)
        members.append(newTeam)
    }
    
    func removeMember(at indexSet: IndexSet) {
            members.remove(atOffsets: indexSet) // Supprimer les éléments à partir de l'indexSet
        }
    
}

struct MemberView: View{
    let member: Team
    let teamStore: TeamStore
    var body: some View {
        NavigationLink(destination: MemberDetailView( teamStore: teamStore, member: member))  {
        HStack(spacing:3){
            
                AsyncImage(url: URL(string: member.imageUrl) ?? URL(string: "https://images.pexels.com/photos/428364/pexels-photo-428364.jpeg")!) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .aspectRatio(contentMode: .fit)
                    case .failure, .empty:
                        ProgressView()
                    @unknown default:
                        EmptyView()
                    }
                }
            
            HStack{
            VStack(alignment: .leading, spacing: 4) {
                Text(member.name.isEmpty ? "non renseigné" : member.name)
                    .foregroundColor(.gray)
                    .font(.system(size:20))
               
                Text("\(formattedDate(date: member.creationDate))")
                        .font(.subheadline)
                Text("\(member.salary)€")
                    .font(.system(size:18))
                    .bold()
            }
 
            
                
            Spacer()
            VStack(alignment: .center, spacing: 0) {
                Text("\(member.rating)")
                    Image(systemName: "star.fill")
                    .font(.system(size:24))
                
            }.foregroundColor(member.color==(.indigo) ? .white : .indigo)
                    .font(.system(size:40))
                    .bold()
            }.padding([.leading],6)
                .padding([.trailing],0)
                
        }
        .frame(height:90)
            
        
    }
        .padding([.trailing],8)
        .background(member.color)
        
            

    }
    
    func formattedDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        return dateFormatter.string(from: date)
    }
}

// main content
struct ContentView: View {
    @ObservedObject var teamStore = TeamStore()
    @State private var isShowingAddTeamView = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.indigo.edgesIgnoringSafeArea(.all)
                Spacer()
                List {
                    ForEach(teamStore.members) { member in
                        MemberView(member:member, teamStore:teamStore)
                        }
                    .onDelete{ IndexSet in teamStore.members.remove(atOffsets: IndexSet)
                    }.listRowInsets(EdgeInsets())
                        
                    
                }.padding(12)
                
                .listStyle(PlainListStyle())
                .navigationBarItems(leading:
                                HStack {
                                    Text("Votre Team")
                                        .font(.system(size: 32))
                                        .bold()
                                        .foregroundColor(.white)
                                    Spacer()
                                },
                                trailing: NavigationLink(destination: AddMemberView(teamStore: teamStore)) {
                                    Image(systemName: "plus")
                                        .padding([.vertical], 7)
                                        .padding([.horizontal], 16)
                                        .background(Color(.white))
                                        .foregroundColor(.indigo)
                                        .cornerRadius(10)
                                        .font(.system(size: 20))
                                        .bold()
                                }
                            )
            }
          
        }
    }
    
    
    func deleteMember(at offsets: IndexSet) {
            teamStore.members.remove(atOffsets: offsets)
        }
    
}

    
    
struct MemberDetailView: View {
    @ObservedObject var teamStore: TeamStore
    let member :Team
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
                    }
                }
            }
            .navigationTitle("Modifier le membre \(member.name)")
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
