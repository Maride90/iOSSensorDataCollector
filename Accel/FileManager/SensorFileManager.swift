//
//  File.swift
//  Accel
//
//  Created by  on 3/10/20.
//  Copyright © 2020 . All rights reserved.
//

import Foundation

enum SensorType:String {
    case accelerometer, gyrsocope
}

struct SensorFileManager {
    
    static let shared = SensorFileManager()
    private init() {}
    
    /* COLUMNS */
    //xAcc    yAcc    zAcc     xGyr    yGyr    zGyr     xMag     yMag    zMag ActivityN  ActN  SubjectN
    public func saveData(_ data: Any, _ activity: ActivityType, _ sensorType: SensorType) {
        
        var string = ""
        if (data is AccelModel) {
            let accelData = data as! AccelModel
            string = String(format: "%f,%f,%f,%f,%d,%@\n", accelData.x, accelData.y, accelData.z, timestampFromLastBootTime(accelData.timestamp), activity.rawValue, "\(activity)")
        } else if (data is GyroModel) {
            let gyroData = data as! GyroModel
            string = String(format: "%f,%f,%f,%f,%d,%@\n", gyroData.x, gyroData.y, gyroData.z, timestampFromLastBootTime(gyroData.timestamp), activity.rawValue, "\(activity)")
        }
                
        let filename = evaluateFileName(activity, sensorType)
        saveDataToFile(filename: filename, string: string)
        
    }
    
    private func evaluateFileName(_ activity: ActivityType, _ sensorType: SensorType) -> String {
        let df = DateFormatter()
            df.dateFormat = "dd-MM-yyyy"
        let date = df.string(from: Date())
        let user = SensorManager.shared.user
        
        let sensor = sensorType == .accelerometer ? "Accel" : "Gyro"
        
        let filename = "\(activity.rawValue)_\(activity)_\(date)_\(user)_\(sensor).csv"
        
        return filename
    }
    
    
    public func appendCalcsFor(activity: ActivityType, sensorType: SensorType, stats: NSDictionary) {
        
        let x = stats.object(forKey: "X") as! Stats
        let y = stats.object(forKey: "Y") as! Stats
        let z = stats.object(forKey: "Z") as! Stats
        
        let calcs =
            "\n=======================================\n"
        
        +   "X MAX:,\(NSString(format:"%.4f", x.max))\n"
        +   "X MEDIAN:,\(NSString(format:"%.4f", x.median))\n"
        +   "X MEAN:,\(NSString(format:"%.4f", x.mean))\n"
        +   "X STDEV:,\(NSString(format:"%.4f", x.stdev))\n"
        +   "X MIN:,\(NSString(format:"%.4f", x.min))\n"
        +   "X COUNT:,\(NSString(format:"%d", x.count))\n"
        +   "X ZeroCross:,\(NSString(format:"%d", x.zc))\n"
                
        +   "------------------------------------------\n"
                
        +   "Y MAX:,\(NSString(format:"%.4f", y.max))\n"
        +   "Y MEDIAN:,\(NSString(format:"%.4f", y.median))\n"
        +   "Y MEAN:,\(NSString(format:"%.4f", y.mean))\n"
        +   "Y STDEV:,\(NSString(format:"%.4f", y.stdev))\n"
        +   "Y MIN:,\(NSString(format:"%.4f", y.min))\n"
        +   "Y COUNT:,\(NSString(format:"%d", y.count))\n"

        +   "------------------------------------------\n"
                
        +   "Z MAX:,\(NSString(format:"%.4f", z.max))\n"
        +   "Z MEDIAN:,\(NSString(format:"%.4f", z.median))\n"
        +   "Z MEAN:,\(NSString(format:"%.4f", z.mean))\n"
        +   "Z STDEV:,\(NSString(format:"%.4f", z.stdev))\n"
        +   "Z MIN:,\(NSString(format:"%.4f", z.min))\n"
        +   "Z COUNT:,\(NSString(format:"%d", z.count))\n"
        +   "Z ZeroCross:,\(NSString(format:"%d", z.zc))\n"
                
        +   "=======================================\n"
        
        let filename = evaluateFileName(activity, sensorType)
        saveDataToFile(filename: filename, string: calcs)
        
        
    }
    
    public func removeLastExperimentData() {
        removeLastExperimentFiles()
    }
    
    public func removeAllFiles() {
        removeLastExperimentFiles(true)
    }
    
    public func listAllExperiments() -> [String] {
        return listAllFiles()
    }
    
    public func allFilePaths() -> [URL] {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return [] }

        do {
            return try FileManager.default.contentsOfDirectory(at: documentsDirectory, includingPropertiesForKeys: nil, options: [])
        } catch {
            print("Could not search for urls of files in documents directory: \(error)")
        }
        
        return []
    }
    
    //"Accel.csv"
    private func saveDataToFile(filename: String, string: String) {
        
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        let fileURL = documentsDirectory.appendingPathComponent(filename)
       
        guard let data = string.data(using: String.Encoding.utf8) else { return }

        if FileManager.default.fileExists(atPath: fileURL.path) {
            if let fileHandle = try? FileHandle(forWritingTo: fileURL) {
                fileHandle.seekToEndOfFile()
                fileHandle.write(data)
                fileHandle.closeFile()
            }
        } else {
            try? data.write(to: fileURL, options: .atomicWrite)
        }
    }
    
    
    private func removeLastExperimentFiles(_ removeAll: Bool = false) {
        
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }

        do {
            let directoryContents = try FileManager.default.contentsOfDirectory(at: documentsDirectory, includingPropertiesForKeys: nil, options: [])
            
            var pathWithCreationDate = [[Date:URL]]()
            
            for filePath in directoryContents {
                do {
                    let attributes = try FileManager.default.attributesOfItem(atPath: filePath.path)
                    let date = attributes[.creationDate] as! Date
                    pathWithCreationDate.append([date:filePath])
                } catch {
                    print("Error with file listing: \(error)")
                }
            }
            
            print(pathWithCreationDate)
            let sortedFiles = pathWithCreationDate.sorted(by: { $0.keys.first!.compare($1.keys.first!) == .orderedDescending })
            
            var count = 0
            for file in sortedFiles {
                if(!removeAll && count >= 2) {
                    break
                }
                                
                try FileManager.default.removeItem(at:file.values.first!)
                
                count += 1
            }
            
        } catch {
            print("Could not search for urls of files in documents directory: \(error)")
        }
                
    }
    
    private func listAllFiles() -> [String] {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return [String]() }

           do {
                let directoryContents = try FileManager.default.contentsOfDirectory(at: documentsDirectory, includingPropertiesForKeys: nil, options: [])

                var pathWithCreationDate = [[Date:URL]]()

                for filePath in directoryContents {
                   do {
                       let attributes = try FileManager.default.attributesOfItem(atPath: filePath.path)
                       let date = attributes[.creationDate] as! Date
                       pathWithCreationDate.append([date:filePath])
                   } catch {
                       print("Error with file listing: \(error)")
                   }
                }

                print(pathWithCreationDate)
                let sortedFiles = pathWithCreationDate.sorted(by: { $0.keys.first!.compare($1.keys.first!) == .orderedDescending })

                var files = [String]()

                for file in sortedFiles {
                    
                    let fileName = file.values.first!.absoluteURL.lastPathComponent
                    
                    let df = DateFormatter()
                    df.dateFormat = "MMM d, HH:mm"
                    let date = df.string(from: file.keys.first!)
                    
                    files.append("\(date) |  \(fileName)")
                }
            
                return files
        } catch {
            print("Could not search for urls of files in documents directory: \(error)")
        }
        
        return [String]()
    }
    
    func timestampFromLastBootTime(_ timeLeftFromLastBoot: TimeInterval) -> TimeInterval {
        let now = Date().timeIntervalSince1970
        let systemBootTimestamp = now - ProcessInfo.processInfo.systemUptime
        let sensorTimestamp = systemBootTimestamp + timeLeftFromLastBoot
        return sensorTimestamp
    }
}
