//
//  ViewController.swift
//  ASLRecognition
//
//  Created by Edoardo Troianiello on 29/08/23.
//

import UIKit
import SwiftUI



struct HostedViewController: UIViewControllerRepresentable {
    var predictionObject: PredictionObject
    func makeUIViewController(context: Context) -> UIViewController {
        return ARViewController(predictionObject: predictionObject)
        }

        func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        }
}
