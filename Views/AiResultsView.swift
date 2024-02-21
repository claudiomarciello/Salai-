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
        ZStack{
            Rectangle().opacity(0.01).frame(width: 1000, height: 600)
                .foregroundStyle(.gray)
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
                    .font(.title3)
                // .fontWeight(.thin)
                Button(action: {print("button")}){
                    HStack{
                        Image(systemName: "wand.and.stars")
                            .resizable()
                            .foregroundStyle(.white)
                            .frame(width: 30, height: 30)
                            .padding(.leading)
                        Text("Generate a new sketch")
                            .font(.body)
                            .fontWeight(.regular)
                            .foregroundStyle(.white)
                            .padding()
                    }
                    .frame(width: 250)
                    .background(.black)
                    .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                }
                
                
                
            }}
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
