//
//  AppDelegate.swift
//  ASLRecognition
//
//  Created by Edoardo Troianiello on 19/06/23.
//

import Foundation
import AVFoundation
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playback, mode: .moviePlayback, options: [])
        } catch {
            print("Failed to set audio session category")
        }
        
        return true
    }
}
