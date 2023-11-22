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
    var totalSalary: Int {
            teamStore.members.reduce(0) { total, member in
                total + Int(member.salary) * 2
            }
        }
    var lowestRatedHighestPaidMemberName: String {
        let sortedMembers = teamStore.members.sorted {
            if $0.rating == $1.rating {
                return $0.salary > $1.salary
            }
            return $0.rating < $1.rating
        }

        if let lowestRating = sortedMembers.first?.rating {
            let lowestRatedMembers = sortedMembers.filter { $0.rating == lowestRating }
            if lowestRatedMembers.count == 1 {
                return lowestRatedMembers[0].name
            } else {
                let highestPaidMember = lowestRatedMembers.reversed().max(by: { $0.salary < $1.salary })
                return highestPaidMember?.name ?? ""
            }
        }

        return ""
    }
    
    let colorLight = Color(red:228/255, green:228/255, blue:242/255)
    var body: some View {
        NavigationView {
            
            VStack(alignment: .center, spacing: 8) {
                
                HStack{
                    Text("Coût de l'équipe: ")
                    Text("\(totalSalary) €")
                        .bold()
                        
                }.font(.system(size: 22))
                    .foregroundColor(colorLight)
                    .padding(.top, 20)
                    .padding(.horizontal)
                    
                
                HStack{
                    Text("Maillon faible de l'équipe : ")
                    
                    Text(lowestRatedHighestPaidMemberName)
                        .bold()
                        .font(.system(size:20))
                    }.font(.system(size:18))
                
                Divider()
                 .frame(height: 2)
                 .background(colorLight)
                
                List {
                    ForEach(teamStore.members) { member in
                        VStack {
                            MemberView(member: member, teamStore: teamStore)
                            Spacer()
                        }
                        .background(.indigo)
                    }
                    .onDelete { IndexSet in
                        teamStore.members.remove(atOffsets: IndexSet)
                    }
                    .listRowInsets(EdgeInsets())
                }
                .padding(12)
                .background(Color.indigo)
                .cornerRadius(15)
                .padding(.horizontal)
                .listStyle(PlainListStyle())
                
                .navigationBarItems(
                    leading: Text("Equipe")
                        .font(.system(size: 32))
                        .bold()
                        .foregroundColor(colorLight),
                    trailing: NavigationLink(destination: AddMemberView(teamStore: teamStore)) {
                        Image(systemName: "plus")
                            .padding([.vertical], 8)
                            .padding([.horizontal], 8)
                            .background(colorLight)
                            .foregroundColor(.indigo)
                            .cornerRadius(20)
                            .font(.system(size: 20))
                            .bold()
                    }
                )
            }
            .background(Color.indigo.edgesIgnoringSafeArea(.all))
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
