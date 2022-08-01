//
//  HeartBeatViewController.swift
//  TopicRun
//
//  Created by 이규환 on 2022/07/25.
//

import UIKit
import AVFoundation
import SpriteKit
import HealthKit
import WatchConnectivity

class HeartBeatViewController: BottomSheetViewController {
//MARK: - private 변수 생성
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    //bpm 숫자

    var bpm = 0
    var session = WCSession.default
    var timer = Timer()

    // HeartBeatView
    private lazy var heartBeatView: SKView = {
        let view = SKView()
        let scene = SKScene(fileNamed: "AnimatedIphoneHearts.sks")
        view.backgroundColor = .clear
        
        view.presentScene(scene)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    //alertview
    private lazy var alertView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "BottomBack")
        view.layer.cornerRadius = 10
        view.alpha = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    //alertword
    private lazy var alertword: UILabel = {
        let text = UILabel()
        text.textColor = .black
        text.textAlignment = .center
        text.numberOfLines = 1
        text.text = "Stop 버튼을 길게 누르면 주제 선정이 종료됩니다."
        text.font = UIFont(name: "Helvetica Neue", size: 18)
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    //stopButton
    private lazy var stopButton : UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 20
        button.setTitle("Stop!", for: .normal)
        button.setTitleColor(UIColor(named: "StopColor"), for: .normal)
        button.titleLabel?.font = UIFont(name: "Helvetica Neue", size: 22)
        button.titleLabel?.font = .systemFont(ofSize: 22, weight: .bold)
        button.backgroundColor = .black
        button.frame = CGRect(x: 0, y: 0, width: 168, height: 40)
        button.layer.cornerRadius = 20
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    // keyword
    private lazy var keyword: UILabel = {
        let text = UILabel()
        text.textColor = UIColor(named: "Keyword")
        text.textAlignment = .center
        text.text = ""
        text.font = UIFont(name: "Helvetica Neue", size: 20)
        text.font = .systemFont(ofSize: 20, weight: .bold)
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    // bpmLabel
    private lazy var bpmLabel: UILabel = {
        let text = UILabel()
        text.text = "- - / 120 BPM"
        text.font = UIFont(name: "Helvetica Neue", size: 28)
        text.font = .systemFont(ofSize: 28, weight: .bold)
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
//MARK: - setup UI and Layout
    override func setupUI() {
        super.setupUI()
        bottomSheetView.addSubview(stopButton)
        bottomSheetView.addSubview(keyword)
        bottomSheetView.addSubview(bpmLabel)
        bottomSheetView.addSubview(heartBeatView)
        view.addSubview(alertView)
        alertView.addSubview(alertword)
    }

    override func setupLayout() {
        super.setupLayout()
        // keyword
        NSLayoutConstraint.activate([
            keyword.topAnchor.constraint(equalTo: bottomSheetView.topAnchor, constant: 33),
            keyword.centerXAnchor.constraint(equalTo: bottomSheetView.centerXAnchor)
        ])
        // heartBeatView
        NSLayoutConstraint.activate([
            heartBeatView.centerXAnchor.constraint(equalTo: bottomSheetView.centerXAnchor),
            heartBeatView.topAnchor.constraint(equalTo: bottomSheetView.topAnchor, constant: 60),
            heartBeatView.bottomAnchor.constraint(equalTo: bpmLabel.topAnchor, constant: -10),
            heartBeatView.heightAnchor.constraint(equalToConstant: 63),
            heartBeatView.widthAnchor.constraint(equalToConstant: 63)
        ])
        // bpmLabel
        NSLayoutConstraint.activate([
            bpmLabel.topAnchor.constraint(equalTo: bottomSheetView.topAnchor, constant: 139),
            bpmLabel.centerXAnchor.constraint(equalTo: bottomSheetView.centerXAnchor)
        ])
        // stopButton
        NSLayoutConstraint.activate([
            stopButton.topAnchor.constraint(equalTo: bottomSheetView.topAnchor, constant: 194),
            stopButton.heightAnchor.constraint(equalToConstant: stopButton.frame.height),
            stopButton.widthAnchor.constraint(equalToConstant: stopButton.frame.width),
            stopButton.centerXAnchor.constraint(equalTo: bottomSheetView.centerXAnchor)
        ])
        // alertView
        NSLayoutConstraint.activate([
            alertView.topAnchor.constraint(equalTo: view.topAnchor, constant: 114),
            alertView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant:  16),
            alertView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant:  -16),
            alertView.bottomAnchor.constraint(equalTo: view.topAnchor, constant: 176)
        ])
        // alerword
        NSLayoutConstraint.activate([
            alertword.centerYAnchor.constraint(equalTo: alertView.centerYAnchor),
            alertword.centerXAnchor.constraint(equalTo: alertView.centerXAnchor)
        ])

    }
//MARK: - override of BottomSheetVC
    override var defaultHeight: CGFloat {275}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dimmedView.removeFromSuperview()
        indicatorView.removeFromSuperview()
        // long press
        let longpress = MyLongPressGesture(target: self, action: #selector(stopLong(_:)))
        longpress.delaysTouchesBegan = false
        longpress.delaysTouchesEnded = false
        longpress.minimumPressDuration = 0.5
        stopButton.addGestureRecognizer(longpress)
        stopButton.addTarget(self, action: #selector(alert), for: .touchUpInside)
        collectHeartRate()
        keyword.text = "#" + " " + markerInfo.keyword[0] + " " + "#" + " " + markerInfo.keyword[1]
        changeText()
        let tap = UITapGestureRecognizer(target: self, action: #selector(touchSaveTest(_:)))
        heartBeatView.addGestureRecognizer(tap)
    }
    
    override func bottomSheetViewPanned(_ panGestureRecognizer: UIPanGestureRecognizer) {}
}
//MARK: - private func for UI
extension HeartBeatViewController {
    
    private func changeText() {
        guard let text = self.alertword.text else { return }
        let attributeString = NSMutableAttributedString(string: text)
        attributeString.addAttribute(.foregroundColor, value: UIColor.red, range: (text as NSString).range(of: "Stop"))
        attributeString.addAttribute(.font, value: UIFont.systemFont(ofSize: 22,weight: .bold), range: (text as NSString).range(of: "Stop"))
        self.alertword.attributedText = attributeString
    }
    
    @objc private func alert() {
        UIDevice.vibrate()
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseInOut, animations: {
            self.alertView.alpha = 1
        }, completion: nil)
        UIView.animate(withDuration: 0.4, delay: 1, options: .curveEaseInOut, animations: {
            self.alertView.alpha = 0
            }, completion: nil)
    }
    
    @objc private func stopLong(_ gesture : MyLongPressGesture) {
        switch gesture.state {
        case.began:
            UIDevice.vibrate()
            UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.9,options: .curveEaseInOut, animations: {
                self.view?.transform = CGAffineTransform(scaleX: 1, y: 1)
            }, completion: nil)
            hideBottomSheet()
            
            workOutStop()
            
        default:
            return
        }
    }

    
    private func isReachable() -> Bool {
        return session.isReachable
    }
    
    func workOutStop() {
        // AppleWatch에 [WorkOut 세션 종료] 명령 메시지 전달
        if self.isReachable() {
//            do {
//                timer.invalidate()
//                try self.session.updateApplicationContext(["action": "stop"])
//            } catch {
//                print("error")
//            }
        } else {
            print("AppleWatch is not reachable...!")
        }
    }
    
    // 심박수 가져오고 Label 업데이트
    func collectHeartRate() {
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
            if HKHealthStore.isHealthDataAvailable() {
                if WCSession.isSupported() {
                    if let heartValue = WCSession.default.receivedApplicationContext["request"] {
                        print("HeartBeatViewController: \(WCSession.default.receivedApplicationContext)")
                        self.bpmLabel.text = "\(heartValue) / 120 BPM"
                    } else {
                        self.bpmLabel.text = "- - / 120 BPM"
                    }
                }
            }
        })
    }

    @objc private func touchSaveTest(_ gesture: UITapGestureRecognizer) {
//        appDelegate.persistentContainer.addTopic(keyword: "나 돌아갈래", topic: "으ㅏ아아아")
        let vc = FinalBottomViewController()
        vc.modalPresentationStyle = .overFullScreen
        vc.markerInfo = self.markerInfo
        vc.mapTimer = self.mapTimer
        vc.timerText = self.timerText
        self.present(vc, animated: false)

    }
}
//MARK: - override of BottomSheetVC
class MyLongPressGesture : UILongPressGestureRecognizer {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesBegan(touches, with: event)
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.9,options: .curveEaseInOut, animations: {
            self.view?.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }, completion: nil)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesEnded(touches, with: event)
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.9,options: .curveEaseInOut, animations: {
            self.view?.transform = CGAffineTransform(scaleX: 1, y: 1)
        }, completion: nil)
    }
}

//MARK: - [extension 정의 실시 - UIDevice]
extension UIDevice {
    static func vibrate() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
}
