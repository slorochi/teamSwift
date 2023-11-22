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
                        VStack{ MemberView(member:member, teamStore:teamStore)
                            Spacer()}
                        .background(.indigo)
                        }
                    .onDelete{ IndexSet in teamStore.members.remove(atOffsets: IndexSet)
                    }
//                    .listStyle(PlainListStyle())
                    .listRowInsets(EdgeInsets())
//                    .listRowSeparatorTint(.indigo)
            
                        
                    
                }.padding(12)
                    .scrollContentBackground(.hidden)
                    .background(.indigo)
//                .listStyle(PlainListStyle())
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




struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
