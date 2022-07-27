//
//  HeartBeatViewController.swift
//  TopicRun
//
//  Created by 이규환 on 2022/07/25.
//

import UIKit

class HeartBeatViewController: BottomSheetViewController {
    
    override var defaultHeight: CGFloat {275}
    var bpm: Int {60}
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
            text.text = "# 건강 # 스케줄"
            text.font = UIFont(name: "Helvetica Neue", size: 20)
            text.font = .systemFont(ofSize: 20, weight: .bold)
            text.translatesAutoresizingMaskIntoConstraints = false
            return text
        }()
    // bpm
    private lazy var bpmLabel: UILabel = {
        let text = UILabel()
        text.text = "\(bpm) / 120"
        text.font = UIFont(name: "Helvetica Neue", size: 28)
        text.font = .systemFont(ofSize: 28, weight: .bold)
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dimmedView.removeFromSuperview()
        indicatorView.removeFromSuperview()
        let longpress = UILongPressGestureRecognizer(target: self, action: #selector(stopHeartBeat(_:)))
//        let touch = UILongPressGestureRecognizer(target: self, action: #selector(touchStopButton(_:)))
//        touch.delaysTouchesEnded = false
//        touch.delaysTouchesBegan = false
        longpress.minimumPressDuration = 0
        longpress.delaysTouchesBegan = false
        longpress.delaysTouchesEnded = false
//        stopButton.addTarget(self, action: #selector(touchStopButton), for: .touchUpInside)
//        touch.minimumPressDuration = 2
        stopButton.addGestureRecognizer(longpress)
//        stopButton.addGestureRecognizer(touch)
        
    }
    
    override func setupUI() {
        super.setupUI()
        bottomSheetView.addSubview(stopButton)
        bottomSheetView.addSubview(keyword)
        bottomSheetView.addSubview(bpmLabel)
    }
    
    override func setupLayout() {
        super.setupLayout()
//      keyword
        NSLayoutConstraint.activate([
            keyword.topAnchor.constraint(equalTo: bottomSheetView.topAnchor, constant: 33),
            keyword.centerXAnchor.constraint(equalTo: bottomSheetView.centerXAnchor)
        ])
//      bpmLabel
        NSLayoutConstraint.activate([
            bpmLabel.topAnchor.constraint(equalTo: keyword.bottomAnchor, constant: 82),
            bpmLabel.centerXAnchor.constraint(equalTo: bottomSheetView.centerXAnchor)
        ])
//      stopButton
        NSLayoutConstraint.activate([
            stopButton.topAnchor.constraint(equalTo: bottomSheetView.topAnchor, constant: 194),
            stopButton.heightAnchor.constraint(equalToConstant: stopButton.frame.height),
            stopButton.widthAnchor.constraint(equalToConstant: stopButton.frame.width),
            stopButton.centerXAnchor.constraint(equalTo: bottomSheetView.centerXAnchor)
        ])
    }
    
    override func bottomSheetViewPanned(_ panGestureRecognizer: UIPanGestureRecognizer) {
    }

}

extension HeartBeatViewController {
    @objc private func stopHeartBeat(_ gesture : UILongPressGestureRecognizer) {
        switch gesture.state {
        case .possible:
            print("touch")
        case .began :
            print("touch")
        case .changed :
            print("change")
        
        case .ended :
            //stop
            print("end")
            hideBottomSheet()

        case .cancelled:
            print("cancel")
        case .failed:
            print("fail")
        
        default:
            print("default")
        }//gesture.state
    }//stopHeartBeat
    @objc private func touchStopButton() {
        print("Start")
    }

}
