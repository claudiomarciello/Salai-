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
            Text("Ai")
                .font(.system(size: 96))
                .font(.title)
                .fontWeight(.bold)
                .padding(.bottom, -20)
            Text("results")
                .font(.system(size: 96))
                .fontWeight(.bold)
                .padding(.top, -20)
            Text("Upload here your illustrations for train your digital support")
                .font(.headline)
                .fontWeight(.thin)
            Button(action: {print("button")}){
                HStack{
                    Image(systemName: "wand.and.stars")
                        .resizable()
                        .foregroundStyle(.white)
                        .frame(width: 30, height: 30)
                    Text("Generate a new sketch")
                        .foregroundStyle(.white)
                    }
                .frame(width: 250)
                .background(.black)
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            }
            
                
            
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
    AiResultsView(selected: .constant(0))
}
