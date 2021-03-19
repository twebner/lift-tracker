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
    @State private var accelerationAverages: [Double] = []
    @State private var numReps = 0
    private let motion = CMMotionManager()
    
    var body: some View {
        let buttonText = isRecording ? "Stop" : "Start"
        let buttonAction = isRecording ? stopRecording : startRecording
        VStack {
            if numReps > 0 {
                Text("\(numReps) reps")
            }
            Button(buttonText, action: buttonAction)
        }
    }
    
    private func startRecording() {
        accelerationData.removeAll()
        isRecording = true
        if motion.isDeviceMotionAvailable {
            motion.deviceMotionUpdateInterval = 1.0 / 60.0
            motion.showsDeviceMovementDisplay = true
            motion.startDeviceMotionUpdates(to: OperationQueue.current!,
                                            withHandler: { (data, error) in
                                                if let validData = data {
                                                    accelerationData.append(validData.userAcceleration)
                                                }
                                            })
        }
    }
    
    private func stopRecording() {
        isRecording = false
        motion.stopDeviceMotionUpdates()
        countReps()
    }
    
    private func countReps() {
        printRawData()
        calculateRunningAverageX(count: 20)
        calculateReps()
    }
    
    private func printRawData() {
        print("\nRaw Acceleration Data")
        accelerationData.forEach { accelerationReading in
            print("\(truncate(accelerationReading.x)), \(truncate(accelerationReading.y)), \(truncate(accelerationReading.z))")
        }
    }
    
    private func calculateRunningAverageX(count: Int) {
        print("\nRunning Average (\(count))")
        var runningSum = 0.0
        for (index, element) in accelerationData.enumerated() {
            runningSum += element.x
            
            let numElements: Int
            if index < count {
                numElements = index + 1
            } else {
                numElements = count
                let removeIndex = index - count
                runningSum -= accelerationData[removeIndex].x
            }
            let average = runningSum / Double(numElements)
            accelerationAverages.append(average)
            print("\(truncate(average))")
        }
    }
    
    private func calculateReps() {
        numReps = 0
        var prevValue: Double?
        for (index, value) in accelerationAverages.enumerated() {
            if index > 0 {
                // We calculate a rep by counting the number of times the running average goes from negative to positive
                if prevValue! < 0 && value > 0 {
                    numReps += 1
                }
            }
            prevValue = value
        }
    }
    
    private func truncate(_ number: Double) -> String {
        return String(format: "%.5f", number)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
