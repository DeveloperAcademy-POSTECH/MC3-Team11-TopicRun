//
//  FindTopicViewController.swift
//  TopicRun
//
//  Created by 이규환 on 2022/07/20.
//

import UIKit

class FindTopicViewController: BottomSheetViewController {

    private lazy var buttonView : UIView = {
        makeButtonView()
    }()
    
    let config = UIImage.SymbolConfiguration(pointSize: 16, weight: .semibold)
    lazy var xmark = UIImage(systemName: "xmark", withConfiguration: config)
    lazy var xmarkView = UIImageView.init(image: xmark)
    
    //MARK: - override from BottomSheetViewController
    
    override var defaultHeight: CGFloat {196}
    
    override func viewDidLoad() {
        let buttomTap = UITapGestureRecognizer(target: self, action: #selector(buttonClosed))
        buttonView.addGestureRecognizer(buttomTap)
        buttonView.isUserInteractionEnabled = true
        xmarkView.tintColor = .white
        super.viewDidLoad()

    }
    
    override func setupUI() {

        super.setupUI()
        bottomSheetView.addSubview(buttonView)
        buttonView.addSubview(xmarkView)

    }
    
    override func setupLayout() {
        
        super.setupLayout()
        buttonView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buttonView.topAnchor.constraint(equalTo: bottomSheetView.topAnchor, constant: 16),
            buttonView.heightAnchor.constraint(equalToConstant: buttonView.frame.width),
            buttonView.widthAnchor.constraint(equalToConstant: buttonView.frame.height),
            buttonView.trailingAnchor.constraint(equalTo: bottomSheetView.trailingAnchor, constant: -16)
        ])
        
        xmarkView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            xmarkView.centerXAnchor.constraint(equalTo: buttonView.centerXAnchor),
            xmarkView.centerYAnchor.constraint(equalTo: buttonView.centerYAnchor)
        ])
    }
    
}


//MARK: - CotainsButtonProtocol

extension FindTopicViewController : ContainsButton {
    
    func makeButtonView() -> UIView {
        let closedButton = UIView()
        closedButton.layer.backgroundColor = UIColor.black.cgColor
        closedButton.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
        closedButton.layer.cornerRadius = closedButton.bounds.size.width / 2
        return closedButton
    }

    @objc func buttonClosed() {
        hideBottomSheet()
        print("button")
    }
}
