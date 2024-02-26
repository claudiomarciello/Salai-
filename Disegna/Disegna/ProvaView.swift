//
//  ProvaView.swift
//  Disegna
//
//  Created by LorenzoSpinosa on 26/02/24.
//

import SwiftUI

struct ProvaView: View {
    var body: some View {
        ZStack{
            Text("è questa!")
            storyboardView().edgesIgnoringSafeArea(.all)
        }
    }
    
    //importa la storyboard
    struct storyboardView: UIViewControllerRepresentable{
        func makeUIViewController(context: Context) ->  UIViewController {
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let controller = storyboard.instantiateViewController(withIdentifier:"Canva")
            return controller
        }
        func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
            //  UIViewRepresentable
        }
        
    }
}
