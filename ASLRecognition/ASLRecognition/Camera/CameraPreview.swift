//
//  CameraPreview.swift
//  ASLRecognition
//
//  Created by Edoardo Troianiello on 19/06/23.
//


import UIKit
import AVFoundation

final class CameraPreview: UIView {
    
    ///  This makes the root layer of this view of type AVCaptureVideoPreviewLayer.
    override class var layerClass: AnyClass {
        AVCaptureVideoPreviewLayer.self
    }
    ///Now we can use this property to access the layer directly when you need to work with it later.
    var previewLayer: AVCaptureVideoPreviewLayer {
        layer as! AVCaptureVideoPreviewLayer
    }
    
}
