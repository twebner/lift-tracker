//
//  ContentView.swift
//  Lift Tracker WatchKit Extension
//
//  Created by Tyler Webner on 3/18/21.
//

import SwiftUI
import CoreMotion

struct ContentView: View {
    @State private var isRecording = false
    @State private var accelerationData: [CMAcceleration] = []
    //    @State private var recordingTime
    let motion = CMMotionManager()

    var body: some View {
        let buttonText = isRecording ? "Stop" : "Start"
        let buttonAction = isRecording ? stopRecording : startRecording
        Button(buttonText, action: buttonAction)
        if isRecording {
            
        }
    }
    
    func startRecording() {
        accelerationData.removeAll()
        isRecording = true
        if motion.isDeviceMotionAvailable {
            motion.deviceMotionUpdateInterval = 1.0 / 1.0
            motion.showsDeviceMovementDisplay = true
            motion.startDeviceMotionUpdates(to: OperationQueue.current!,
                                            withHandler: { (data, error) in
                                                if let validData = data {
                                                    accelerationData.append(validData.userAcceleration)
                                                }
                                            })
        }
    }
        
    func stopRecording() {
        isRecording = false
        motion.stopDeviceMotionUpdates()
        
        print("Acceleration Data:")
        accelerationData.forEach { accelerationReading in
            print("x: \(truncate(number: accelerationReading.x))\ty: \(truncate(number: accelerationReading.y))\tz: \(truncate(number: accelerationReading.z))")
        }
    }
    
    private func truncate(number: Double) -> String {
        return String(format: "%.3f", number)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
