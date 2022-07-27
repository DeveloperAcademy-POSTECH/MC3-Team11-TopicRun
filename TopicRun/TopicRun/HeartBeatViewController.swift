//
//  HeartBeatViewController.swift
//  TopicRun
//
//  Created by 이규환 on 2022/07/25.
//

import UIKit
import Combine
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
        let longpress = MyLongPressGesture(target: self, action: #selector(stopLong(_:)))
        longpress.delaysTouchesBegan = false
        longpress.delaysTouchesEnded = false
        stopButton.addGestureRecognizer(longpress)
        longpress.minimumPressDuration = 1
        stopButton.addTarget(self, action: #selector(alert), for: .touchUpInside)
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
    @objc private func alert() {
        let customVC = CustomAlertViewController()
        customVC.modalPresentationStyle = .overFullScreen
        self.present(customVC, animated: false, completion: nil)
    }
}

extension HeartBeatViewController {
    @objc private func stopLong(_ gesture : MyLongPressGesture) {
        hideBottomSheet()
    }
}

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
