//
//  PredictionObject.swift
//  ASLRecognition
//
//  Created by Edoardo Troianiello on 30/08/23.
//

import Foundation

class PredictionObject: ObservableObject {
    @Published var label: String = ""
    @Published var confidence: Double = 0.0
}
