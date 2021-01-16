//
//  SensorManager.swift
//  Accel
//
//  Created by  on 3/23/20.
//  Copyright © 2020 . All rights reserved.
//

enum ActivityType: Int, CaseIterable {
    case fallingRight = 1, fallingLeft, fallingForward, fallingBackward, sittingFast, jumping
}

enum ActivityUser: Int, CaseIterable {
    case user1 = 1, user2, user3, user4, user5, user6, user7, user8, user9, user10, user11, user12, user13, user14
}

class SensorManager {

    static let shared = SensorManager()

    private let accel = AccelerometerReader()
    private let gyro = GyroscopeReader()
    
    private let accelDescriptStats = DescriptStatsWrapper()
    private let gyroDescriptStats = DescriptStatsWrapper()

    
    public private(set) var activityType: ActivityType = .fallingRight
    public private(set) var user: ActivityUser = .user1
    
    private init() {}
    
    public func setActivityType(_ activity:ActivityType) {
        if(!self.accel.isSensorActive() && !self.gyro.isSensorActive()) {
            self.activityType = activity
        } else {
            print("Sensors already started, cant set new activity type. Please stop sensors and set again")
        }
    }
    
    public func setActivityUser(_ user:ActivityUser) {
        if(!self.accel.isSensorActive() && !self.gyro.isSensorActive()) {
            self.user = user
        } else {
            print("Sensors already started, cant set new user. Please stop sensors and set again")
        }
    }
    
    
    public func sensorsStarted() -> Bool {
        if(accel.isSensorActive() && gyro.isSensorActive()) {
            return true
        }
        return false
    }
    
    public func startSensors() {
        if(!accel.isSensorActive()) {
            accel.startAccelerometerRecordings { (data, error) in
                if(error != nil) {
                    return
                }
                guard let data = data else {
                    return
                }
                
                let accelModel = AccelModel(x: data.acceleration.x, y: data.acceleration.y, z: data.acceleration.z, timestamp: data.timestamp)
                self.accelDescriptStats?.addNewDataX(data.acceleration.x,
                                                     y: data.acceleration.y,
                                                     z: data.acceleration.z)
                SensorFileManager.shared.saveData(accelModel, self.activityType, .accelerometer)
            }
        }
        if(!gyro.isSensorActive()) {
            gyro.startGyroscopeRecordings { (data, error) in
                if(error != nil) {
                    return 
                }
                guard let data = data else {
                    return
                }
                let gyroModel = GyroModel(x: data.rotationRate.x, y: data.rotationRate.y, z: data.rotationRate.z, timestamp: data.timestamp)
                self.accelDescriptStats?.addNewDataX(data.rotationRate.x,
                                                     y: data.rotationRate.y,
                                                     z: data.rotationRate.z)
                SensorFileManager.shared.saveData(gyroModel, self.activityType, .gyrsocope)
            }
        }
    }
    
    public func stopSensors() {
        if(accel.isSensorActive()) {
            accel.stopAccelerometerRecordings()
            let statsTotal = (self.accelDescriptStats?.getDataTotal())!
            SensorFileManager.shared.appendCalcsFor(activity: self.activityType, sensorType: .accelerometer, stats: statsTotal as NSDictionary)
        }
        if(gyro.isSensorActive()){
            gyro.stopGyroscopeRecordings()
            let statsTotal = (self.gyroDescriptStats?.getDataTotal())!
            SensorFileManager.shared.appendCalcsFor(activity: self.activityType, sensorType: .gyrsocope, stats: statsTotal as NSDictionary)
        }
        
    }
    
    
}
