//
//  ContentView.swift
//  ASLRecognition
//
//  Created by Edoardo Troianiello on 19/06/23.
//

import SwiftUI

struct ContentView: View {
    @State private var overlayPoints: [CGPoint] = []
    
    var body: some View {
        ZStack{
            CameraView {
                overlayPoints = $0
            }
            .overlay(
                FingersOverlay(with: overlayPoints)
                    .foregroundColor(.red)
            )
            .edgesIgnoringSafeArea(.all)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
