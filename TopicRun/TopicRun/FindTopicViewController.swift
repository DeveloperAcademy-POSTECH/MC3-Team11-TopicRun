//
//  FindTopicViewController.swift
//  TopicRun
//
//  Created by 이규환 on 2022/07/20.
//

import UIKit

class FindTopicViewController: BottomSheetViewController {

    private lazy var buttonView : UIButton = {
        makeButtonView()
    }()
    
    //MARK: - override from BottomSheetViewController
    
    override var defaultHeight: CGFloat {400}
    
    
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
            buttonView.topAnchor.constraint(equalTo: bottomSheetView.topAnchor, constant: 20),
            buttonView.trailingAnchor.constraint(equalTo: bottomSheetView.trailingAnchor, constant: -20)
        ])
    }
    
}


//MARK: - CotainsButtonProtocol

extension FindTopicViewController : ContainsButton {
    
    func makeButtonView() -> UIButton {
        let closedButton = UIButton(type: .system)
        closedButton.backgroundColor = .black
        closedButton.frame = CGRect(x: 0, y: 0, width: 28, height: 28)
        closedButton.layer.cornerRadius = closedButton.bounds.size.width / 2
        return closedButton
    }

    @objc func buttonClosed() {
        hideBottomSheet()
        print("button")
    }
}
