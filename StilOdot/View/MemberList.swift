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
    let indigoDark = Color(red: 75/255, green: 71/255, blue:196/255)

    
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
                        VStack(alignment: .leading, spacing: 12) {
                        
                            Text(member.name.isEmpty ? "non renseigné" : member.name)
                                .font(.system(size:21))
                                .bold()
                            HStack{
                                Text("\(formatCurrency(member.salary))€")
                                    .font(.system(size:16))
                                    .italic()
                                Text("\(member.role)")
                                    .font(.system(size:12))
                                    .padding(.leading,6)
                            }
                           
                            
                            
                            
                        }
                        
                        
                        
                        Spacer()
                        VStack(alignment: .center, spacing: 0) {
                            Text("\(member.rating)")
                            
                        }.foregroundColor(.white)
                            .font(.system(size:40))
                            .bold()
                    }.padding([.leading],6)
                        .padding([.trailing],0)
                    
                }
                .foregroundColor(.white)
                .frame(height:90)
                
            }
            .cornerRadius(15)
            .padding([.trailing],8)
            .background(.indigo)
            .border(.indigo, width: 2)
        }

    func formatCurrency(_ amount: Double) -> String {
           let numberFormatter = NumberFormatter()
           numberFormatter.numberStyle = .currency
           numberFormatter.currencySymbol = "€"
           numberFormatter.maximumFractionDigits = 0

           return numberFormatter.string(from: NSNumber(value: amount)) ?? ""
       }
    
    func formattedDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        return dateFormatter.string(from: date)
    }
}
