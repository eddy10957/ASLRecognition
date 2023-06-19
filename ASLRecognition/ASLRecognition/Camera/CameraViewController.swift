//
//  CameraViewController.swift
//  ASLRecognition
//
//  Created by Edoardo Troianiello on 19/06/23.
//


import AVFoundation
import UIKit
import Vision
/// The camera capture code from AVFoundation is designed to work with UIKit, so to get it working nicely in our  SwiftUI app we need to make a view controller and wrap it in UIViewControllerRepresentable.

final class CameraViewController: UIViewController {
    
    private var cameraView: CameraPreview { view as! CameraPreview }
    private var cameraFeedSession: AVCaptureSession?
    private var audioSession: AVAudioSession?
    
    private let videoDataOutputQueue = DispatchQueue(
        label: "CameraFeedOutput",
        qos: .userInteractive
    )
    
    private let handPoseRequest: VNDetectHumanHandPoseRequest = {
        let request = VNDetectHumanHandPoseRequest()
        
        request.maximumHandCount = 1
        return request
    }()
    
    var pointsProcessorHandler: (([CGPoint]) -> Void)?
    
    override func loadView() {
        view = CameraPreview()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        do {
            if cameraFeedSession == nil {
                try setupAVSession()
                
                cameraView.previewLayer.session = cameraFeedSession
                cameraView.previewLayer.videoGravity = .resizeAspectFill
                DispatchQueue.global(qos: .background).async{
                    self.cameraFeedSession?.startRunning()
                }
                
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        cameraFeedSession?.stopRunning()
    }
    
    func processPoints(_ fingerTips: [CGPoint]) {
        let convertedPoints = fingerTips.map {
            cameraView.previewLayer.layerPointConverted(fromCaptureDevicePoint: $0)
        }
        
        pointsProcessorHandler?(convertedPoints)
    }
    
    func setupAVSession() throws {
        let audioSession = AVAudioSession()
        do {
            try audioSession.setCategory(AVAudioSession.Category.playAndRecord, options: AVAudioSession.CategoryOptions.mixWithOthers)
        } catch {
            print("Error 1")
        }
        
        do {
            try audioSession.setMode(AVAudioSession.Mode.videoRecording)
        } catch {
            print("Error 2")
        }
        
        do {
            try audioSession.setActive(true)
        } catch {
            print("Error 3")
        }
        
        guard let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera,
                                                        for: .video,
                                                        position: .front)
        else {
            throw AppError.captureSessionSetup(
                reason: "Could not find a front facing camera."
            )
        }
        
        guard let deviceInput = try? AVCaptureDeviceInput(device: videoDevice) else {
            throw AppError.captureSessionSetup(
                reason: "Could not create video device input."
            )
        }
        
        let session = AVCaptureSession()
        session.beginConfiguration()
        session.sessionPreset = AVCaptureSession.Preset.high
        session.automaticallyConfiguresApplicationAudioSession = false
        
        guard session.canAddInput(deviceInput) else {
            throw AppError.captureSessionSetup(
                reason: "Could not add video device input to the session"
            )
        }
        session.addInput(deviceInput)
        
        let dataOutput = AVCaptureVideoDataOutput()
        if session.canAddOutput(dataOutput) {
            session.addOutput(dataOutput)
            dataOutput.alwaysDiscardsLateVideoFrames = true
            dataOutput.setSampleBufferDelegate(self, queue: videoDataOutputQueue)
        } else {
            throw AppError.captureSessionSetup(
                reason: "Could not add video data output to the session"
            )
        }
        
        session.commitConfiguration()
        cameraFeedSession = session
    }
}

extension CameraViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        var fingerTips: [CGPoint] = []
        
        defer {
            DispatchQueue.main.sync {
                self.processPoints(fingerTips)
            }
        }
        
        let handler = VNImageRequestHandler(cmSampleBuffer: sampleBuffer,
                                            orientation: .up,
                                            options: [:]
        )
        
        do {
            try handler.perform([handPoseRequest])
            
            guard let results = handPoseRequest.results?.prefix(1),
                  !results.isEmpty
            else {
                return
            }
            var recognizedPoints: [VNRecognizedPoint] = []
            
            try results.forEach { observation in
                let fingers = try observation.recognizedPoints(.all)
                
                if let thumbTipPoint = fingers[.thumbTip] {
                    recognizedPoints.append(thumbTipPoint)
                }
                
                if let indexTipPoint = fingers[.indexTip] {
                    recognizedPoints.append(indexTipPoint)
                }
                
                if let middleTipPoint = fingers[.middleTip] {
                    recognizedPoints.append(middleTipPoint)
                }
                
                if let ringTipPoint = fingers[.ringTip] {
                    recognizedPoints.append(ringTipPoint)
                }
                
                if let littleTipPoint = fingers[.littleTip] {
                    recognizedPoints.append(littleTipPoint)
                }
            }
            
            fingerTips = recognizedPoints.filter {
                $0.confidence > 0.90
            }.map {
                CGPoint(x: $0.location.x, y: 1 - $0.location.y)
            }
            print(fingerTips)
        } catch {
            cameraFeedSession?.stopRunning()
        }
    }
}

enum AppError: Error {
    case captureSessionSetup(reason: String)
}
