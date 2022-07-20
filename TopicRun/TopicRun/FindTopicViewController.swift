//
//  FindTopicViewController.swift
//  TopicRun
//
//  Created by 이규환 on 2022/07/20.
//

import UIKit

class FindTopicViewController: BottomSheetViewController, ContainsButton{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let buttomTap = UITapGestureRecognizer(target: self, action: #selector(buttonClosed))
        buttonView.addGestureRecognizer(buttomTap)
        buttonView.isUserInteractionEnabled = true
    }
    
    override func setupUI() {
        super.setupUI()
        view.addSubview(buttonView)
    }
    
    override func setupLayout() {
        super.setupLayout()
        buttonView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buttonView.bottomAnchor.constraint(equalTo: bottomSheetView.topAnchor, constant: 40),
            buttonView.trailingAnchor.constraint(equalTo: bottomSheetView.trailingAnchor, constant: -20)
        ])
        
    }
    
    
    var buttonView: UIButton = {
        let closedButton = UIButton(type: .system)
        closedButton.backgroundColor = .black
        closedButton.layer.masksToBounds = true
        print(closedButton.frame.width)
        closedButton.layer.cornerRadius = closedButton.frame.width / 2
        return closedButton
    }()

    
    
    func buttonClosed() {
        hideBottomSheet()
        print("button")
    }
    
    
    

}
