//
//  ContentView.swift
//  salai
//
//  Created by Francesca Mangino on 17/02/24.
//

import SwiftUI

struct ContentView: View {
    @State var selected = 0
    let filterOptions: [String] = ["Ai Results","Portfolio"]
    enum SwipeHorizontalDirection: String {
        case left, right, none
    }
    @State var swipeHorizontalDirection: SwipeHorizontalDirection = .none { didSet { print(swipeHorizontalDirection) } }
    
    
    
    init(){
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor.black
        
        let attributes:[NSAttributedString.Key:Any] = [
            .foregroundColor : UIColor.white,

        ]
        UISegmentedControl.appearance().setTitleTextAttributes(attributes, for: .selected)
        UISegmentedControl.appearance().backgroundColor = UIColor.init(white: 1, alpha: 0.2)
        UISegmentedControl.appearance().layer.cornerRadius = 100

    }

    var body: some View {
        
        Picker(selection: $selected,
               label: Text("Picker"),
               content: {
            ForEach(filterOptions.indices){ index in Text(filterOptions[index])
                    .tag(filterOptions[index])
                    
            }
            
        })
        .pickerStyle(SegmentedPickerStyle())
        .padding()
        .padding(.horizontal)
       
        if selected == 0{
            AiResultsView(selected: $selected)
            }
        else{
            PortfolioView(selected: $selected)
                
            }
        
    }
}

#Preview {
    ContentView()
}
