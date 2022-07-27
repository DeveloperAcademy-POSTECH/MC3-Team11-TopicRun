//
//  StartPageViewController.swift
//  TopicRun
//
//  Created by Shin yongjun on 2022/07/19.
//

import Foundation
import UIKit
import HealthKit
import WatchConnectivity

class StartPageViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var NicknameTextField: UITextField!
    @IBOutlet weak var topicRunButton: UIButton!
    @IBOutlet var heartRateLabel: UILabel!
    
    let healthStore = HKHealthStore()
    let heartRateUnit:HKUnit = HKUnit(from: "count/min")
    let heartRateType:HKQuantityType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!
    var heartRateQuery:HKQuery?
    
    var timer = Timer()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        authorizeHealthKit()
        
    }
    
    override func viewDidLoad() {
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        NicknameTextField.delegate = self
        topicRunButton.isEnabled = false
        topicRunButton.alpha = 0.5
        
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
            if HKHealthStore.isHealthDataAvailable() {
                self.getLatestHeartRate()
            }
        })
    }
    
    
    @IBAction func topicRunButtonPressed(_ sender: UIButton) {
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text = (NicknameTextField.text! as NSString).replacingCharacters(in: range, with: string)
        if text.isEmpty {
            topicRunButton.isEnabled = false
            topicRunButton.alpha = 0.5
        } else {
            topicRunButton.isEnabled = true
            topicRunButton.alpha = 1.0
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        self.view.endEditing(true)
        return true
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    func authorizeHealthKit() {
        let allTypes = Set([
            HKObjectType.quantityType(forIdentifier: .heartRate)!])
        
        healthStore.requestAuthorization(toShare: allTypes, read: allTypes) { (success, error) in
            if success {
                print("허용 완료")
            }
        }
    }
    
    func getLatestHeartRate()
    {
        let startDate = Date.distantPast
        let endDate = Date()
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: [])
        
        let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate)!
        let sortDescriptors = [NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)]
        
        let  heartRateQuery =  HKSampleQuery(sampleType: heartRateType, predicate: predicate, limit: 1, sortDescriptors: sortDescriptors, resultsHandler: { (query, results, error) in
            guard  let result = results else { return }
            if(results!.count > 0){
            guard let currData = result[0] as? HKQuantitySample else { return }
            let beatsPerMinuteUnit = HKUnit.count().unitDivided(by: HKUnit.minute())
            DispatchQueue.main.async {
                self.heartRateLabel.text = String(Int(currData.quantity.doubleValue(for: beatsPerMinuteUnit)))
                print("Heart Rate: " + String(Int(currData.quantity.doubleValue(for: beatsPerMinuteUnit))))
                print("Start Date: \(currData.startDate)")
            }
            }
        })
        healthStore.execute(heartRateQuery)
        
    }
}
