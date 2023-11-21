//
//  ContentView.swift
//  StilOdot
//
//  Created by LANDA Théo on 20/11/2023.
//

//let backgroundUrl = URL(string:"stering")
//AsyncImage(url:backgroundUrl){
//    image in image
//} placeholder:{Rectangle().foregroundColor(.gray)}


import SwiftUI
import UIKit

struct Team:Identifiable {
    let id = UUID()
    let imageUrl: String
    let name: String
    let role: String
    let rating: Double
    let salary: Int
    let creationDate: Date
    let color: Color
}

class TeamStore: ObservableObject {
    @Published var members: [Team] = []
    
    func addMember(imageUrl: String, name: String, role: String, rating: Double,salary:Int, creationDate: Date, color: Color) {
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
                List {
                    ForEach(teamStore.members) { member in
                            HStack(alignment: .center, spacing: 0) {
                                AsyncImage(url: URL(string: "https://images.pexels.com/photos/428364/pexels-photo-428364.jpeg")) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                } placeholder: {
                                    ProgressView()
                                }
                                .frame(width: 70, height: 70)
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(member.name)
                                        .font(.headline)
                                        .foregroundColor(.gray)
                                    HStack(spacing:4){
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
                            .padding(2)
                            .background(member.color)
                            .cornerRadius(8)
                    }
                }
                
                Button("Add Team") {
                    isShowingAddTeamView.toggle()
                }
                .sheet(isPresented: $isShowingAddTeamView) {
                    AddMemberView(teamStore: teamStore)
                }
                .padding()
            }
            .navigationTitle("Gestion d'équipe")
        }
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
    @State private var rating = 0.0
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
                    Stepper(value: $rating, in: 0...10, step: 1) {
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

// ------APP GOMOKU------
// called by the app
//struct ContentView: View {
//
//    @StateObject var gomokuGame = GomokuGame() // Gestion du jeu Gomoku
//
//    var body: some View {
//        VStack {
//            GameBoardView(gomokuGame: gomokuGame) // Affiche le plateau de jeu
//                .frame(width: 280, height: 280) // Taille du plateau de jeu
//        }
//        .padding()
//    }
//}
//
//struct GameBoardView: View {
//    let boardSize = 19  // Taille de la grille (15x15 pour Gomoku)
//    let gridSize: CGFloat = 20 // Taille d'une intersection de la grille
//
//    @ObservedObject var gomokuGame: GomokuGame // ObservableObject pour mettre à jour la vue
//
//    var body: some View {
//        ZStack {
//            Image("devilsplan")
//                .resizable()
//                .aspectRatio(contentMode: .fill)
//                .frame(maxWidth: .infinity, maxHeight: .infinity)
//                .opacity(0.95)
//                .edgesIgnoringSafeArea(.all) // Ignorer les marges sûres pour remplir tout l'écran
//            VStack(spacing: 0) {
//
//                Text("Gomoku")
//                    .font(.system(size:36)).foregroundColor(Color.white)
//                    .padding(20)
//                    .background(Color.indigo)
//                Spacer()
//                ForEach(0..<boardSize, id: \.self) { row in
//                    HStack(spacing: 0) {
//                        ForEach(0..<boardSize, id: \.self) { col in
//
//                            Rectangle() // Intersection de la grille
//                                .frame(width: self.gridSize, height: self.gridSize)
//                                .border(Color.gray) // Ajoute une bordure pour chaque intersection
//
//                                .onTapGesture {
//                                    gomokuGame.makeMove(row: row, col: col)
//                                }
//                                .foregroundColor(getPlayerColor(player: gomokuGame.board[row][col])) // Change la couleur du pion
//                        }
//                    }
//                    .background(Color.indigo) // Définir la couleur de fond du plateau de jeu comme noir
//
//                }
//
//
//            }
//        }
//    }
//    func getPlayerColor(player: Player) -> Color {
//            switch player {
//            case .black:
//                return .black
//            case .white:
//                return .white
//            default:
//                return .clear
//            }
//        }
//}
//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
//
//
//enum Player {
//    case none, black, white
//}
//
//class GomokuGame: ObservableObject { // Modifier la classe pour qu'elle soit conforme à ObservableObject
//    @Published var board: [[Player]]
//    @Published var currentPlayer: Player
//
//    init() {
//        self.board = Array(repeating: Array(repeating: .none, count: 19), count: 19) // Plateau de 19x19
//        self.currentPlayer = .black // Joueur noir commence
//    }
//
//    func makeMove(row: Int, col: Int) {
//        if board[row][col] == .none {
//            board[row][col] = currentPlayer
//            // Implémenter la logique de vérification de la victoire ici
//            // Vérifier si le joueur actuel a gagné
//            // Sinon, passer au prochain joueur
//        }
//    }
//}

//class GameBoardView: UIView {
//    let boardSize = 15 // Taille de la grille (15x15 pour Gomoku)
//    let gridSize = 30 // Taille d'une intersection de la grille
//
//    var board: [[Player]] = [] // Matrice pour stocker l'état du jeu
//    var currentPlayer: Player = .black // Joueur actuel
//
//    override func draw(_ rect: CGRect) {
//        super.draw(rect)
//        drawBoard() // Dessiner le plateau initial
//    }
//
//    func drawBoard() {
//        // Dessiner la grille
//        for i in 0..<boardSize {
//            for j in 0..<boardSize {
//                let rect = CGRect(x: CGFloat(i * gridSize), y: CGFloat(j * gridSize), width: CGFloat(gridSize), height: CGFloat(gridSize))
//                let path = UIBezierPath(rect: rect)
//                UIColor.lightGray.setFill()
//                path.fill()
//                path.stroke()
//            }
//        }
//    }

//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if let touch = touches.first {
//            let touchLocation = touch.location(in: self)
//            let row = Int(touchLocation.x) / gridSize
//            let col = Int(touchLocation.y) / gridSize
//
//            // Assurez-vous que le mouvement est à l'intérieur des limites du plateau
//            guard row >= 0 && row < boardSize && col >= 0 && col < boardSize else { return }
//
//            // Si l'intersection est vide, placez un pion pour le joueur actuel
//            if board[row][col] == .none {
//                board[row][col] = currentPlayer
//                setNeedsDisplay() // Redessiner le plateau avec le nouveau pion
//                // Ici, vous pouvez ajouter la logique pour changer de joueur
//            }
//        }
//    }
// }
