//
//  CameraView.swift
//  ASLRecognition
//
//  Created by Edoardo Troianiello on 19/06/23.
//

import SwiftUI

struct CameraView: UIViewControllerRepresentable {
    var pointsProcessorHandler: (([CGPoint]) -> Void)?

    
    /// First protocol method, makeUIViewController. Here we initialize an instance of CameraViewController and perform any one time only setups.
    func makeUIViewController(context: Context) -> CameraViewController {
        let cameraViewController = CameraViewController()
        cameraViewController.pointsProcessorHandler = pointsProcessorHandler
        return cameraViewController
    }
    /// Other required method of this protocol, where we would make any updates to the view controller based on changes to the SwiftUI data or hierarchy.
    func updateUIViewController(
        _ uiViewController: CameraViewController,
        context: Context) {
        }
}
