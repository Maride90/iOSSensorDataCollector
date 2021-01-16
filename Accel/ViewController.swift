//
//  ViewController.swift
//  Accel
//
//  Created by  on 1/17/18.
//  Copyright © 2018 . All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController, UIActionSheetDelegate {

    @IBOutlet weak var accelToggle: UIButton!
    @IBOutlet weak var lblActivityType: UILabel!
    @IBOutlet weak var btnActivityType: UIButton!
    @IBOutlet weak var lblAcitivtyUser: UILabel!
    @IBOutlet weak var btnActivityUser: UIButton!
    @IBOutlet weak var textExperimentFilesList: UITextView!
    
    @IBOutlet weak var btnCancelLastExperiment: UIButton!
    @IBOutlet weak var btnRemoveAllLocalData: UIButton!
    @IBOutlet weak var btnShareRecordings: UIButton!
    
    let motionManager = CMMotionManager()
    var accelInProgress = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sensorsStoppedUIUpdate()
        updateActivityType(SensorManager.shared.activityType)
        updateActivityUser(SensorManager.shared.user)
        updateExperimentListTextView()
                
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBAction func accelToggle(_ sender: Any) {
        if(SensorManager.shared.sensorsStarted()) {
            sensorsStoppedUIUpdate()
            SensorManager.shared.stopSensors()
        } else {
            sensorsActiveUIUpdate()
            SensorManager.shared.startSensors()
        }
        updateExperimentListTextView()
    }
    
    @IBAction func selectActivityType(_ sender: Any) {
        
        let activityTypeSelectAction = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        
        for activity in ActivityType.allCases {
            activityTypeSelectAction.addAction(UIAlertAction(title: "\(activity)", style: .default , handler:{ (alert: UIAlertAction!) -> Void in
                print("User click \(activity) button")
                SensorManager.shared.setActivityType(activity)
                self.updateActivityType(activity)
            }))
        }
        
        activityTypeSelectAction.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(activityTypeSelectAction, animated: true, completion: nil)
    
    }
    
    @IBAction func selectUser(_ sender: Any) {
           let userSelectAction = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
           
           for user in ActivityUser.allCases {
               userSelectAction.addAction(UIAlertAction(title: "\(user)", style: .default , handler:{ (alert: UIAlertAction!) -> Void in
                   print("User click \(user) button")
                   SensorManager.shared.setActivityUser(user)
                   self.updateActivityUser(user)
               }))
           }
           
           userSelectAction.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
           
           self.present(userSelectAction, animated: true, completion: nil)
        
    }
    
    @IBAction func removeLastExperimentData(_ sender: Any) {
        let confirmAlert = UIAlertController(title: nil, message: "Are you sure to remove LAST EXPERIMENT DATA?", preferredStyle: .alert)
               
        confirmAlert.addAction(UIAlertAction(title: "Confirm", style: .default, handler:{ (alert: UIAlertAction!) -> Void in
            SensorFileManager.shared.removeLastExperimentData()
            self.updateExperimentListTextView()
        }))
        
        confirmAlert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        
        self.present(confirmAlert, animated: true, completion: nil)
    }
    
    @IBAction func clearAllExperimentsData(_ sender: Any) {
        let confirmAlert = UIAlertController(title: nil, message: "Are you sure to remove ALL EXPERIMENTS FROM THE PHONE?", preferredStyle: .alert)
                      
        confirmAlert.addAction(UIAlertAction(title: "Confirm", style: .default, handler:{ (alert: UIAlertAction!) -> Void in
            SensorFileManager.shared.removeAllFiles()
            self.updateExperimentListTextView()
        }))

        confirmAlert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))

        self.present(confirmAlert, animated: true, completion: nil)
    }
    
    
    @IBAction func shareRecords(_ sender: Any) {
        let filesToShare = SensorFileManager.shared.allFilePaths()
        
        if (filesToShare.count == 0) {
            let confirmAlert = UIAlertController(title: nil, message: "No Records to share", preferredStyle: .alert)
            confirmAlert.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: nil))
            self.present(confirmAlert, animated: true, completion: nil)
            return
        }
        
        let activityViewController = UIActivityViewController(activityItems: filesToShare, applicationActivities: nil)
        self.present(activityViewController, animated: true, completion: nil)
    }

    
    func updateActivityType(_ activity:ActivityType) {
        lblActivityType.text = "\(activity)"
    }
    
    func updateActivityUser(_ user:ActivityUser) {
        lblAcitivtyUser.text = "\(user)"
    }
    
    func sensorsActiveUIUpdate() {
        accelToggle.setTitle("Stop Recording", for: .normal)
        btnActivityType.isEnabled = false
        btnActivityUser.isEnabled = false
        btnCancelLastExperiment.isEnabled = false
        btnRemoveAllLocalData.isEnabled = false
        btnShareRecordings.isEnabled = false
    }
    
    func sensorsStoppedUIUpdate() {
        accelToggle.setTitle("Start Recording", for: .normal)
        btnActivityType.isEnabled = true
        btnActivityUser.isEnabled = true
        btnCancelLastExperiment.isEnabled = true
        btnRemoveAllLocalData.isEnabled = true
        btnShareRecordings.isEnabled = true
    }
    
    func updateExperimentListTextView() {
        textExperimentFilesList.text = ""
        for line in SensorFileManager.shared.listAllExperiments() {
            textExperimentFilesList.text += "\(line)\r"
        }
    }
    
}

