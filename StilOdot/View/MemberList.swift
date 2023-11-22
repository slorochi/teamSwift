//
//  MemberList.swift
//  StilOdot
//
//  Created by LANDA Théo on 22/11/2023.
//

import Foundation
import SwiftUI
import UIKit

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
                                .scaledToFit()
                            //                            .aspectRatio(contentMode: .fit)
                                .cornerRadius(5)
                                .frame(height:75)
                        case .failure, .empty:
                            ProgressView()
                        @unknown default:
                            EmptyView()
                        }
                    }
                    
                    HStack{
                        VStack(alignment: .leading, spacing: 4) {
                            Text(member.name.isEmpty ? "non renseigné" : member.name)
                                .foregroundColor(.black)
                                .font(.system(size:22))
                            
                           
                            Text("\(member.salary)€")
                                .font(.system(size:18))
                                .bold()
                        }
                        
                        
                        
                        Spacer()
                        VStack(alignment: .center, spacing: 0) {
                            Text("\(member.rating)")
                            
                        }.foregroundColor(member.color==(.indigo) ? .white : .black)
                            .font(.system(size:40))
                            .bold()
                    }.padding([.leading],6)
                        .padding([.trailing],0)
                    
                }
                .frame(height:90)
                
            }
            .cornerRadius(15)
            .padding([.trailing],8)
            .background(member.color)
            .border(member.color, width: 2)
        }

    func formattedDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        return dateFormatter.string(from: date)
    }
}
