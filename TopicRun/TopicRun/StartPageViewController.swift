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
import SpriteKit

class StartPageViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var NicknameTextField: UITextField!
    @IBOutlet weak var topicRunButton: UIButton!
    @IBOutlet var heartRateLabel: UILabel!
    @IBOutlet weak var sceneInterface: SKView!
    
    let healthStore = HKHealthStore()
    let heartRateUnit:HKUnit = HKUnit(from: "count/min")
    let heartRateType:HKQuantityType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!
    var heartRateQuery:HKQuery?
    
    // 1: WCSession 프로퍼티 선언
    private var session = WCSession.default
    var timer = Timer()
    var startFlag = 0
    var heartRate = 0.0
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        authorizeHealthKit()
        
        // 3: Session property를 통해 communicatoin 메소드 구현, counterpart(iPhone)의 응답 관리
        if self.isReachable() {
            do {
                try self.session.updateApplicationContext(["action": "stop"])
            } catch {
                print("error")
            }
        } else {
            print("AppleWatch is not reachable...!")
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 2: Sesssion 초기화, InterfaceController를 Delegate로 지정
        if isSupported() {
            session.delegate = self
            session.activate()
        }
        
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
            if HKHealthStore.isHealthDataAvailable() {
                //self.getLatestHeartRate()
                if WCSession.isSupported() {
                    let heartValue = WCSession.default.receivedApplicationContext["request"]
                    print(WCSession.default.receivedApplicationContext)
                
                    self.heartRateLabel.text = "\(heartValue ?? 0)"
                }
                print()
            }
        })
        
        // 3: Session property를 통해 communicatoin 메소드 구현, counterpart(iPhone)의 응답 관리
        if self.isReachable() {
            do {
                try self.session.updateApplicationContext(["action": "stop"])
            } catch {
                print("error")
            }
        } else {
            print("AppleWatch is not reachable...!")
        }
        

        
        
        
        
        // 키보드
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        NicknameTextField?.delegate = self
        topicRunButton?.isEnabled = false
        topicRunButton?.alpha = 0.5
        
        //        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
        //            if HKHealthStore.isHealthDataAvailable() {
        //             self.getLatestHeartRate()
        // }
        // })
    }
    
    
    @IBAction func topicRunButtonPressed(_ sender: UIButton) {
        
    }
    
    func collectHeartRate() {
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
            if HKHealthStore.isHealthDataAvailable() {
                //self.getLatestHeartRate()
                if WCSession.isSupported() {
                    let heartValue = WCSession.default.receivedApplicationContext["request"]
                    print(WCSession.default.receivedApplicationContext)
                
                    self.heartRateLabel.text = "\(heartValue ?? 0)"
                }
                print()
            }
        })
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
    
    //    func getLatestHeartRate()
    //    {
    //        let startDate = Date.distantPast
    //        let endDate = Date()
    //        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: [])
    //
    //        let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate)!
    //        let sortDescriptors = [NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)]
    //
    //        let  heartRateQuery =  HKSampleQuery(sampleType: heartRateType, predicate: predicate, limit: 1, sortDescriptors: sortDescriptors, resultsHandler: { (query, results, error) in
    //            guard  let result = results else { return }
    //            if(results!.count > 0){
    //            guard let currData = result[0] as? HKQuantitySample else { return }
    //            let beatsPerMinuteUnit = HKUnit.count().unitDivided(by: HKUnit.minute())
    //            DispatchQueue.main.async {
    //                self.heartRateLabel.text = String(Int(currData.quantity.doubleValue(for: beatsPerMinuteUnit)))
    //                print("Heart Rate: " + String(Int(currData.quantity.doubleValue(for: beatsPerMinuteUnit))))
    //                print("Start Date: \(currData.startDate)")
    //            }
    //            }
    //        })
    //        healthStore.execute(heartRateQuery)
    //
    //    }
    
    private func isSupported() -> Bool {
        return WCSession.isSupported()
    }
    
    
    // Conterpart app이 message사용이 가능한지 확인
    private func isReachable() -> Bool {
        return session.isReachable
    }
    
}

extension StartPageViewController: WCSessionDelegate {
    func sessionDidBecomeInactive(_ session: WCSession) {
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("activationDidCompleteWith activationState:\(activationState) error: \(String(describing: error))")
    }
}
