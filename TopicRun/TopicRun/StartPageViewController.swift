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
    
    // WCSession 프로퍼티 선언
    var session = WCSession.default
    var timer = Timer()
    
    // userDefaults 기본 객체 참조
    let userDefaults = UserDefaults.standard
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // AppleWatch에 [WorkOut 세션 시작] 명령 메시지 전달
        do {
            try self.session.updateApplicationContext(["action": "start"])
        } catch {
            print("error")
        }
        
        collectHeartRate()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // WCSesssion 초기화, StartPageViewController를 Delegate로 지정
        if isSupported() {
            session.delegate = self
            session.activate()
        }
        
        // 키보드 사용 관련
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        NicknameTextField?.delegate = self
        topicRunButton?.isEnabled = false
        topicRunButton?.alpha = 0.5
        
        let myUser:String = UserDefaults.standard.string(forKey: "nickName") ?? ""
        NicknameTextField.text = myUser
    }
    
    
    @IBAction func topicRunButtonPressed(_ sender: UIButton) {
        timer.invalidate()
//        // AppleWatch에 [WorkOut 세션 시작] 명령 메시지 전달
//        do {
//            try self.session.updateApplicationContext(["action": "start"])
//        } catch {
//            print("error")
//        }
        view.endEditing(true)
        userDefaults.set(NicknameTextField.text, forKey: "nickName")
    }
    
    
// MARK: - 1초마다 HeartRate 데이터 수집
    func collectHeartRate() {
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
            if HKHealthStore.isHealthDataAvailable() {
                if WCSession.isSupported() {
                    if let heartValue = WCSession.default.receivedApplicationContext["request"] {
                        print("StartPageViewController: \(WCSession.default.receivedApplicationContext)")
                        self.heartRateLabel.text = "\(heartValue)"
                    } else {
                        self.heartRateLabel.text = "- -"
                    }
                }
            }
        })
    }
    

// MARK: - 사용자 닉네임 입력을 위한 TextField 관련 함수
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

    
// MARK: - 키보드 관련 함수
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

    
// MARK: - Counterpart app이 message사용이 가능한지 확인
    private func isSupported() -> Bool {
        return WCSession.isSupported()
    }
    
    
    private func isReachable() -> Bool {
        return session.isReachable
    }
    
}


// MARK: - WCSessionDelegate
extension StartPageViewController: WCSessionDelegate {
    func sessionDidBecomeInactive(_ session: WCSession) {
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("activationDidCompleteWith activationState:\(activationState) error: \(String(describing: error))")
    }
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        
    }
}
