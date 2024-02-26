//
//  ContentView.swift
//  Disegna
//
//  Created by LorenzoSpinosa on 26/02/24.
//

import UIKit
import SwiftUI

struct ContentView: View {
    @State private var showProvaView = false
    var body: some View {
        
        NavigationView {
            NavigationLink(destination: ProvaView()) {
                Text("toy plane")
                    .font(.title)
                    .foregroundColor(.white)
                    .background(Color.black.opacity(0.8))
                    .cornerRadius(8)
                
            }
        }
    }
}

//importa la storyboard
