//
//  AiResultsView.swift
//  salai
//
//  Created by Francesca Mangino on 17/02/24.
//

import SwiftUI
import PhotosUI
import StableDiffusion

struct AiResultsView: View {
    @Binding var generating: Bool
    @Binding var isOverlayVisible: Bool

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
                    .font(.system(size: 192))
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.bottom, -40)
                Text("results")
                    .font(.system(size: 192))
                    .fontWeight(.bold)
                    .padding(.top, -40)
                
                // .fontWeight(.thin)
                Button(action: {
                    //generating=true
                    isOverlayVisible=true})
                {
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
    AiResultsView(generating: .constant(false), isOverlayVisible: .constant(false), selected: .constant(0))
}
