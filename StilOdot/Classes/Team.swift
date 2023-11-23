//
//  Team.swift
//  StilOdot
//
//  Created by LANDA Théo on 23/11/2023.
//

import Foundation
import SwiftUI
import UIKit

// MEMBER
struct Team: Identifiable, Codable {
    var id = UUID()
    var imageUrl: String
    var name: String
    var role: String
    var rating: Int
    var salary: Double
    var creationDate: Date
  
    init(imageUrl: String, name: String, role: String, rating: Int, salary: Double, creationDate: Date) {
            self.imageUrl = imageUrl
            self.name = name
            self.role = role
            self.rating = rating
            self.salary = salary
            self.creationDate = creationDate
        }
}
 


// TEAM
class TeamStore: ObservableObject {
    @Published var members: [Team] = []
    
//    func addMember(imageUrl: String, name: String, role: String, rating: Int,salary:Int, creationDate: Date, color: Color) {
//        let newTeam = Team(imageUrl: imageUrl, name: name, role: role, rating: rating, salary: salary, creationDate: creationDate, color: color)
//        members.append(newTeam)
//    }
    
    func removeMember(at indexSet: IndexSet) {
            members.remove(atOffsets: indexSet) // Supprimer les éléments à partir de l'indexSet
        }
}
