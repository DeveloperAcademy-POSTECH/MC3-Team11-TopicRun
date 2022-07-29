//
//  FinalBottomViewController.swift
//  TopicRun
//
//  Created by 이규환 on 2022/07/27.
//

import UIKit

class FinalBottomViewController: BottomSheetViewController {
    
    override var defaultHeight: CGFloat {275}
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    //  Xmark
        let config = UIImage.SymbolConfiguration(pointSize: 16, weight: .semibold)
        lazy var xmark = UIImage(systemName: "xmark", withConfiguration: config)
        private lazy var xmarkView = UIImageView.init(image: xmark)
        
    // Button
        private lazy var closedButton: UIView = {makeButtonView()}()
        
        private lazy var developButton: UIButton = {
            let button = UIButton()
            button.layer.cornerRadius = 20
            button.setTitle("Let’s Develop!", for: .normal)
            button.setTitleColor(UIColor(named: "RunColor"), for: .normal)
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
    
    // topic
    private lazy var topic: UILabel = {
        let text = UILabel()
        text.textAlignment = .center
        text.text = ""
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
            super.viewDidLoad()
            keyword.text = "#" + " " + markerInfo.keyword[0] + " " + "#" + " " + markerInfo.keyword[1]
            topic.text = markerInfo.subject
            dimmedView.removeFromSuperview()
            indicatorView.removeFromSuperview()
            developButton.addTarget(self, action: #selector(saveTopic), for: .touchUpInside)
        }
    override func viewWillAppear(_ animated: Bool) {
    }
        override func setupUI() {
            super.setupUI()
            bottomSheetView.addSubview(closedButton)
            bottomSheetView.addSubview(xmarkView)
            bottomSheetView.addSubview(keyword)
            bottomSheetView.addSubview(topic)
            bottomSheetView.addSubview(developButton)
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
    //      keyword layout
            NSLayoutConstraint.activate([
                keyword.topAnchor.constraint(equalTo: bottomSheetView.topAnchor, constant: 49),
                keyword.centerXAnchor.constraint(equalTo: bottomSheetView.centerXAnchor)
            ])
    //      topic layout
            NSLayoutConstraint.activate([
                topic.topAnchor.constraint(equalTo: keyword.bottomAnchor, constant: 47),
                topic.centerXAnchor.constraint(equalTo: bottomSheetView.centerXAnchor)
            ])
    //      nextButton layout
            NSLayoutConstraint.activate([
                developButton.topAnchor.constraint(equalTo: topic.bottomAnchor, constant: 47),
                developButton.heightAnchor.constraint(equalToConstant: developButton.frame.height),
                developButton.widthAnchor.constraint(equalToConstant: developButton.frame.width),
                developButton.centerXAnchor.constraint(equalTo: bottomSheetView.centerXAnchor)
            ])
        }
    @objc private func saveTopic() {
        let vc = CollectionVC()
        mapTimer?.invalidate()
        
        print(timerText.text!)
        appDelegate.persistentContainer.addTopic(keyword: keyword.text!, topic: topic.text!, runtime: timerText.text!)
//        vc.modalPresentationStyle = .overFullScreen
//        self.present(vc, animated: false)
    }
}

extension FinalBottomViewController: ContainsButton{
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
