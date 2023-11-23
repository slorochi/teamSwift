//
//  ToastView.swift
//  StilOdot
//
//  Created by LANDA Théo on 22/11/2023.
//

import Foundation
import SwiftUI
import UIKit

struct ToastView: View {
    let message: String
    
    var body: some View {
        VStack {
            Text(message)
                .foregroundColor(.white)
                .padding()
                .background(Color.green)
                .cornerRadius(8)
        }
        .padding()
    }
}
