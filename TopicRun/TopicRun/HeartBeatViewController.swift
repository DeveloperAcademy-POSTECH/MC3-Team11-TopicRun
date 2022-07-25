//
//  HeartBeatViewController.swift
//  TopicRun
//
//  Created by 이규환 on 2022/07/25.
//

import UIKit

class HeartBeatViewController: BottomSheetViewController {
    
    override var defaultHeight: CGFloat {275}
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
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stopButton.addTarget(self, action: #selector(stopHeartBeat), for: .touchUpInside)
        // Do any additional setup after loading the view.
    }
//    override func hideBottomSheet() {
//        if self.presentingViewController?.presentingViewController != nil{
//            self.presentingViewController?.presentingViewController?.dismiss(animated: false, completion: nil)
//        }
//    }
    override func setupUI() {
        super.setupUI()
        bottomSheetView.addSubview(stopButton)
    }
    override func setupLayout() {
        super.setupLayout()
        NSLayoutConstraint.activate([
            stopButton.topAnchor.constraint(equalTo: bottomSheetView.topAnchor, constant: 194),
            stopButton.heightAnchor.constraint(equalToConstant: stopButton.frame.height),
            stopButton.widthAnchor.constraint(equalToConstant: stopButton.frame.width),
            stopButton.centerXAnchor.constraint(equalTo: bottomSheetView.centerXAnchor)
        ])
    }
    override func bottomSheetViewPanned(_ panGestureRecognizer: UIPanGestureRecognizer) {
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension HeartBeatViewController {
    @objc private func stopHeartBeat() {
        hideBottomSheet()
    }
}
