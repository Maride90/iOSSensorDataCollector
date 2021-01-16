//
//  AccelerometerManager.swift
//  Accel
//
//  Created by  on 3/23/20.
//  Copyright © 2020 . All rights reserved.
//

import CoreMotion

class AccelerometerReader {

    private var isActive = false
    private let motionManager = CMMotionManager()
    private let updateInterval = 0.05 //20 Hz (every 50 ms)
        
    public func isSensorActive() -> Bool {
        return isActive
    }
    
    public func startAccelerometerRecordings(dataStream:@escaping CMAccelerometerHandler) {
        
        if(isActive || motionManager.isAccelerometerActive) {
            return
        }
        
        if(!motionManager.isAccelerometerAvailable) {
            return
        }
        
        isActive = true
        
        motionManager.accelerometerUpdateInterval = updateInterval
        motionManager.startAccelerometerUpdates(to: OperationQueue.current!, withHandler: dataStream)
    }
    
    public func stopAccelerometerRecordings() {
        motionManager.stopAccelerometerUpdates()
        isActive = false
    }
    
}
