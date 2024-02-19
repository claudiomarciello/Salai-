//
//  PortfolioView.swift
//  salai
//
//  Created by Francesca Mangino on 17/02/24.
//

import SwiftUI

struct PortfolioView: View {
    @Binding var selected: Int
    enum SwipeHorizontalDirection: String {
        case right, none
    }
    @State var swipeHorizontalDirection: SwipeHorizontalDirection = .none { didSet { print(swipeHorizontalDirection) } }

    var viewModel = PortfolioViewModel()
    
    var body: some View {
        VStack{
            Text("Your portfolio")
            
            
            Rectangle().frame(width: 400).foregroundColor(.yellow)
            
        }
            .gesture(DragGesture()
                .onChanged {
                    print("dragging from Portfolio")
                    if $0.startLocation.x < $0.location.x {
                        self.swipeHorizontalDirection = .right
                        selected=0
                        
                    }})
    }
}


#Preview {
    PortfolioView(selected: .constant(0))
}
