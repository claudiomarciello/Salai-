//
//  AiResultsView.swift
//  salai
//
//  Created by Francesca Mangino on 17/02/24.
//

import SwiftUI
import PhotosUI

struct AiResultsView: View {
    
    @Binding var selected: Int
    enum SwipeHorizontalDirection: String {
        case left, none
    }
    @State var swipeHorizontalDirection: SwipeHorizontalDirection = .none { didSet { print(swipeHorizontalDirection) } }
    
    var viewModel = AiResultsViewModel()
    
    var body: some View {
        VStack{
            Text("Ai Results")
            Rectangle().frame(width: 400).foregroundColor(.blue)
        }
            .gesture(DragGesture()
                .onChanged {
                    print("dragging from aiResults")
                    if $0.startLocation.x > $0.location.x {
                        self.swipeHorizontalDirection = .left
                        selected=1
                        
                    }})
    }
}


#Preview {
    AiResultsView(selected: .constant(1))
}
