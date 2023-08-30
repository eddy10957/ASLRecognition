//
//  ARViewController.swift
//  ASLRecognition
//
//  Created by Edoardo Troianiello on 30/08/23.
//

import Foundation
import UIKit
import CoreML
import ARKit
import Vision
import SceneKit

class ARViewController: UIViewController,ARSessionDelegate{
    
    var arScnView: ARSCNView!
    var frameCounter: Int = 0
    let handPosePredictionInterval: Int = 30
    var model = try? ASL_Model(configuration: MLModelConfiguration())
    var viewWidth:Int = 0
    var viewHeight:Int = 0
    var currentHandPoseObservation: VNHumanHandPoseObservation?
    var predictionObject: PredictionObject
  
    
    
    init(predictionObject: PredictionObject) {
        self.predictionObject = predictionObject
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        arScnView = ARSCNView(frame: view.bounds)
        view.addSubview(arScnView)
        viewWidth = Int(arScnView.bounds.width)
        viewHeight = Int(arScnView.bounds.height)
        
        
        let config = ARFaceTrackingConfiguration()
        arScnView.transform = CGAffineTransform(scaleX: -1, y: 1)
        arScnView.session.delegate = self
        arScnView.session.run(config, options: [])
        
        
    }
    
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        
        var pixelBuffer = frame.capturedImage
        DispatchQueue.global(qos: .userInitiated).async { [self] in
            let handPoseRequest = VNDetectHumanHandPoseRequest()
            handPoseRequest.maximumHandCount = 1
            handPoseRequest.revision = VNDetectHumanHandPoseRequestRevision1
            
            let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer,orientation: .right , options: [:])
            do {
                try handler.perform([handPoseRequest])
            } catch {
                assertionFailure("HandPoseRequest failed: \(error)")
            }
            
            
            
            guard let handPoses = handPoseRequest.results, !handPoses.isEmpty else { return }
            guard let observation = handPoses.first else { return }
            currentHandPoseObservation = observation
            frameCounter += 1
            if frameCounter % handPosePredictionInterval == 0 && observation.chirality == .right {
                frameCounter = 0
                makePrediction(handPoseObservation: observation)
            }
            
            
        }
    }
    
    func makePrediction(handPoseObservation: VNHumanHandPoseObservation) {
        guard let keypointsMultiArray = try? handPoseObservation.keypointsMultiArray() else { fatalError() }
        do {
            let prediction = try model!.prediction(poses: keypointsMultiArray)
            let label = prediction.label
            guard let confidence = prediction.labelProbabilities[label] else { return }
            print("label:\(prediction.label)\nconfidence:\(confidence)")
            //            if confidence > 0.8 {
            DispatchQueue.main.async { [self] in
                predictionObject.label = label
                predictionObject.confidence = confidence
            }
            //            }
        } catch {
            print("Prediction error")
        }
    }
    
    
}


