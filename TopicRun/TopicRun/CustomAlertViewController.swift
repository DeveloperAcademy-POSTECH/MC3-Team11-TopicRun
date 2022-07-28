//
//  CustomAlertViewController.swift
//  TopicRun
//
//  Created by 이규환 on 2022/07/28.
//

import UIKit

class CustomAlertViewController: UIViewController {
    private lazy var alertView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "BottomBack")
        view.layer.cornerRadius = 4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setLayout()
        view.isUserInteractionEnabled = false
    }
    
    override func viewWillLayoutSubviews() {
        self.view.frame = CGRect(x: 0, y: 100, width: self.view.frame.width, height: 300            )
        self.view.layer.borderColor = UIColor.red.cgColor
        self.view.layer.borderWidth = 1.0
    }
    
    func setup() {
        view.addSubview(alertView)

    }
    func setLayout() {
        NSLayoutConstraint.activate([
            alertView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 104),
            alertView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant:  16),
            alertView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant:  -16),
            alertView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 176)
        ])
    }
}
