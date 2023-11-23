//
//  ContentView.swift
//  StilOdot
//
//  Created by LANDA Théo on 20/11/2023.
//

import Foundation
import SwiftUI
import UIKit


enum NetworkError: Error {
    case badUrl
    case invalidRequest
    case badResponse
    case badStatus
    case failedToDecodeResponse
}

class WebService: Codable {
    func downloadData<T: Codable>(fromURL: String) async -> T? {
        do {
            guard let url = URL(string: fromURL) else { throw NetworkError.badUrl }
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let response = response as? HTTPURLResponse else { throw NetworkError.badResponse }
            guard response.statusCode >= 200 && response.statusCode < 300 else { throw NetworkError.badStatus }
            guard let decodedResponse = try? JSONDecoder().decode(T.self, from: data) else { throw NetworkError.failedToDecodeResponse }
            
            return decodedResponse
        } catch NetworkError.badUrl {
            print("There was an error creating the URL")
        } catch NetworkError.badResponse {
            print("Did not get a valid response")
        } catch NetworkError.badStatus {
            print("Did not get a 2xx status code from the response")
        } catch NetworkError.failedToDecodeResponse {
            print("Failed to decode response into the given type")
        } catch {
            print("An error occured downloading the data")
        }
        
        return nil
    }
}


// main content
struct ContentView: View {
    // teamstore will automatically load data from init
    @ObservedObject var teamStore = TeamStore()
    @State private var isShowingAddTeamView = false
    var totalSalary: Double {
            teamStore.members.reduce(0) { total, member in
                total + Double(member.salary) * 2
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
    let colorIndigo = Color(red:94/255, green:94/255,blue:225/255)
    let colorLight = Color(red:228/255, green:228/255, blue:242/255)
    let indigoDark = Color(red: 75/255, green: 71/255, blue:196/255)
    let red = Color(red: 245/255, green: 88/255, blue:71/255)
    var body: some View {
        NavigationView {
            
            VStack(alignment: .center, spacing: 8) {
                HStack (alignment: .center){
                    AsyncImage(url: URL(string: "https://cdn-icons-png.flaticon.com/512/1357/1357616.png?ga=GA1.1.215399361.1700747303")) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(height:45)
                                .padding([.bottom,.trailing],8)
                        case .failure, .empty:
                            ProgressView()
                        @unknown default:
                            EmptyView()
                        }
                    }
                Text("Equipe")
                    .font(.system(size: 32))
                    .bold()
                    .foregroundColor(colorLight)
                    .padding([.bottom],8)
                }
                Divider()
                 .frame(height: 2)
                 .background(colorLight)
                                HStack{
                    Text("Coût de l'équipe: ")
                    Text("\(formatCurrency(totalSalary))")
                        .bold()
                   
                        
                }.font(.system(size: 20))
                    .foregroundColor(colorLight)
                    .padding(.top, 6)
                    .padding(.horizontal)
                    
                
                HStack{
                    Text("Maillon faible de l'équipe : ")
                        .foregroundColor(colorLight)
                    Text(lowestRatedHighestPaidMemberName.isEmpty ? "non rensf" : lowestRatedHighestPaidMemberName)
                        .bold()
                        .font(.system(size:19))
                        .foregroundColor(red)
                    }.font(.system(size:16))
                
                HStack{
                    
                }
                
                List {
                    ForEach(teamStore.members) { member in
                        VStack {
                            MemberView(member: member, teamStore: teamStore)
                            Spacer()
                        }
                        .overlay(Rectangle().frame(width: nil, height: 1, alignment: .bottom).foregroundColor(indigoDark), alignment: .bottom)
                        .background(.indigo)
                    }
                    .onDelete { IndexSet in
                        teamStore.members.remove(atOffsets: IndexSet)
                    }
                    .listRowInsets(EdgeInsets())
                }
                .overlay(Rectangle().frame(width: nil, height: 1, alignment: .top).foregroundColor(indigoDark), alignment: .top)
                .cornerRadius(0)
                .listStyle(PlainListStyle())
                
                NavigationLink(destination: AddMemberView(teamStore: teamStore)) {
                        Image(systemName: "plus")
                            .padding([.vertical], 8)
                            .padding([.horizontal], 48)
                            .background(colorLight)
                            .foregroundColor(.indigo)
                            .cornerRadius(12)
                            .font(.system(size: 28))
                            .bold()
                    }
            }
            .background(colorIndigo.edgesIgnoringSafeArea(.all))
            
        }
    }

    func deleteMember(at offsets: IndexSet) {
        teamStore.members.remove(atOffsets: offsets)
    }
    
  
    
    func formatCurrency(_ amount: Double) -> String {
           let numberFormatter = NumberFormatter()
           numberFormatter.numberStyle = .currency
           numberFormatter.currencySymbol = "€"
           numberFormatter.maximumFractionDigits = 2

           return numberFormatter.string(from: NSNumber(value: amount)) ?? ""
       }
}




struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
