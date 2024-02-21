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
        UISegmentedControl.appearance().backgroundColor = UIColor.init(white: 1, alpha: 1)
        UISegmentedControl.appearance().layer.cornerRadius = 100
        
    }

    var body: some View {
        ZStack{
            Image(selected==0 ? "AiResults": "Portfolio")
                .frame(maxWidth: .infinity)
                .frame(maxHeight: .infinity)
            VStack{
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
                .frame(width:800)
                
                
                if selected == 0{
                    AiResultsView(selected: $selected)
                }
                else{
                    PortfolioView(selected: $selected)                    
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
