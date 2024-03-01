//
//  ContainerView.swift
//  Salaì
//
//  Created by Claudio Marciello on 25/02/24.
//

import SwiftUI
import StableDiffusion


struct ContainerView: View {
    @State var generating = false
    var body: some View {
        if generating{
            WaitingView(generating: $generating)}
        else{
            ContentView(generating: $generating)
        }
    }
}

#Preview {
    ContainerView()
}
