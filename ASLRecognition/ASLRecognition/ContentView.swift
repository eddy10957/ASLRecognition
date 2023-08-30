//
//  ContentView.swift
//  ASLRecognition
//
//  Created by Edoardo Troianiello on 19/06/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject var prediction = PredictionObject()
    
    var body: some View {
        VStack{
            HostedViewController(predictionObject: prediction)
                .ignoresSafeArea()
                
            ZStack{
                Rectangle()
                    .frame(height: 200)
                    .foregroundColor(.black)
                Text("Prediction: \(prediction.label), Confidence: \(String(format: "%.2f", prediction.confidence))")
                    .foregroundColor(.white)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
