//
//  GyroscopeManager.swift
//  Accel
//
//  Created by  on 3/23/20.
//  Copyright © 2020 . All rights reserved.
//

import CoreMotion

class GyroscopeReader {
    
    private var isActive = false
    private let motionManager = CMMotionManager()
    private let updateInterval = 0.05 //20 Hz (every 50 ms)
        
    public func isSensorActive() -> Bool {
        return isActive
    }
    
    public func startGyroscopeRecordings(dataStream:@escaping CMGyroHandler) {
        
        if(isActive || motionManager.isGyroActive) {
            return
        }
        
        if(!motionManager.isGyroAvailable) {
            return
        }
        
        isActive = true
        
        motionManager.gyroUpdateInterval = updateInterval
        motionManager.startGyroUpdates(to: OperationQueue.current!, withHandler: dataStream)
    }
    
    public func stopGyroscopeRecordings() {
       motionManager.stopGyroUpdates()
       isActive = false
    }
    
}
