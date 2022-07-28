//
//  FindTopicViewController.swift
//  TopicRun
//
//  Created by 이규환 on 2022/07/20.
//

import UIKit

class FindTopicViewController: BottomSheetViewController {
    
//MARK: - determining defaultHeight of bottomSheetView

    override var defaultHeight: CGFloat {196}
    var keywordFined: String = ""
//MARK: - Create View
    
//  Xmark
    let config = UIImage.SymbolConfiguration(pointSize: 16, weight: .semibold)
    lazy var xmark = UIImage(systemName: "xmark", withConfiguration: config)
    private lazy var xmarkView = UIImageView.init(image: xmark)
    
// Button
    private lazy var closedButton: UIView = {makeButtonView()}()
    
    private lazy var nextButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 20
        button.setTitle("Run!", for: .normal)
        button.setTitleColor(UIColor(named: "RunColor"), for: .normal)
        button.titleLabel?.font = UIFont(name: "Helvetica Neue", size: 22)
        button.titleLabel?.font = .systemFont(ofSize: 22, weight: .bold)
        button.backgroundColor = .black
        button.frame = CGRect(x: 0, y: 0, width: 168, height: 40)
        button.layer.cornerRadius = 20
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
// TextLabel
    private lazy var textLabel: UILabel = {
        let text = UILabel()
        text.tintColor = .black
        text.textAlignment = .center
        text.text = "\(keywordFined)"
        text.font = UIFont(name: "Helvetica Neue", size: 24)
        text.font = .systemFont(ofSize: 24, weight: .bold)
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()

//MARK: - override from BottomSheetViewController
    
    override func viewDidLoad() {
        let buttomTap = UITapGestureRecognizer(target: self, action: #selector(buttonClosed))
        closedButton.addGestureRecognizer(buttomTap)
        closedButton.isUserInteractionEnabled = true
        xmarkView.tintColor = .white
        nextButton.addTarget(self, action: #selector(showNextView), for: .touchUpInside)
        super.viewDidLoad()
    }
    
    override func setupUI() {
        super.setupUI()
        bottomSheetView.addSubview(closedButton)
        bottomSheetView.addSubview(xmarkView)
        bottomSheetView.addSubview(textLabel)
        bottomSheetView.addSubview(nextButton)
    }
    
    override func setupLayout() {
        super.setupLayout()
        
//      closedButton layout
        NSLayoutConstraint.activate([
            closedButton.topAnchor.constraint(equalTo: bottomSheetView.topAnchor, constant: 16),
            closedButton.heightAnchor.constraint(equalToConstant: closedButton.frame.width),
            closedButton.widthAnchor.constraint(equalToConstant: closedButton.frame.height),
            closedButton.trailingAnchor.constraint(equalTo: bottomSheetView.trailingAnchor, constant: -16)
        ])
//      xmarkView layout
        xmarkView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            xmarkView.centerXAnchor.constraint(equalTo: closedButton.centerXAnchor),
            xmarkView.centerYAnchor.constraint(equalTo: closedButton.centerYAnchor)
        ])
        
//         textLabel layout
        NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(equalTo: bottomSheetView.topAnchor, constant: 50),
            textLabel.centerXAnchor.constraint(equalTo: bottomSheetView.centerXAnchor)
        ])
//         nextButton layout
        NSLayoutConstraint.activate([
            nextButton.topAnchor.constraint(equalTo: bottomSheetView.topAnchor, constant: 114),
            nextButton.heightAnchor.constraint(equalToConstant: nextButton.frame.height),
            nextButton.widthAnchor.constraint(equalToConstant: nextButton.frame.width),
            nextButton.centerXAnchor.constraint(equalTo: bottomSheetView.centerXAnchor)
        ])
    }
}

extension FindTopicViewController {
    @objc private func showNextView() {
        let bottomSheetVC = HeartBeatViewController()
        bottomSheetVC.modalPresentationStyle = .overFullScreen
        self.present(bottomSheetVC, animated: false, completion: nil)
    }
}

//MARK: - CotainsButtonProtocol

extension FindTopicViewController: ContainsButton {
    
    func makeButtonView() -> UIView {
        let closedButton = UIView()
        closedButton.translatesAutoresizingMaskIntoConstraints = false
        closedButton.layer.backgroundColor = UIColor.black.cgColor
        closedButton.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
        closedButton.layer.cornerRadius = closedButton.bounds.size.width / 2
        return closedButton
    }

    @objc func buttonClosed() {
        hideBottomSheet()
    }
}
