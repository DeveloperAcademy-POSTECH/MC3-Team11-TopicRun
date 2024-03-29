//
//  SheetViewController.swift
//  TopicRun
//
//  Created by 이규환 on 2022/07/18.
//

import UIKit

class BottomSheetViewController: UIViewController {
    
    var defaultHeight: CGFloat {300}
    
    var markerInfo: MapMarker!
    var mapTimer: Timer!
    var timerText: UILabel!
    
    private lazy var bottomSheetPanStartingTopConstant: CGFloat = bottomSheetViewTopConstraint.constant
    
    let dimmedView: UIView = {
        
        let view = UIView()
        view.backgroundColor = .darkGray.withAlphaComponent(0.7)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var indicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "Indicator")
        view.layer.cornerRadius = 3
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let bottomSheetView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "BottomBack")
        view.layer.cornerRadius = 20
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // 강제 언래핑
    private var bottomSheetViewTopConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLayout()
        indicatorView.isUserInteractionEnabled = false
        
        // GestureRecognizer
            // dimmedTap
        let dimmedTap = UITapGestureRecognizer(target: self, action: #selector(dimmedViewTapped(_:)))
        dimmedTap.delaysTouchesBegan = false
        dimmedTap.delaysTouchesEnded = false
        dimmedView.addGestureRecognizer(dimmedTap)
        dimmedView.isUserInteractionEnabled = true
            // viewPan
        let viewPan = UIPanGestureRecognizer(target: self, action: #selector(bottomSheetViewPanned(_:)))
        viewPan.delaysTouchesBegan = false
        viewPan.delaysTouchesEnded = false
        bottomSheetView.addGestureRecognizer(viewPan)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showBottomSheet()
    }
//MARK: - setup UI and Layout

    func setupUI(){
        view.addSubview(dimmedView)
        view.addSubview(bottomSheetView)
        view.addSubview(indicatorView)
        dimmedView.alpha = 0.0
    }

    func setupLayout(){
        // dimmedView
        NSLayoutConstraint.activate([
            dimmedView.topAnchor.constraint(equalTo: view.topAnchor),
            dimmedView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            dimmedView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dimmedView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        // bottomSheet
        let topConstant = view.safeAreaInsets.bottom + view.safeAreaLayoutGuide.layoutFrame.height
        bottomSheetViewTopConstraint = bottomSheetView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: topConstant)
        NSLayoutConstraint.activate([
            bottomSheetView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            bottomSheetView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            bottomSheetView.bottomAnchor.constraint(greaterThanOrEqualTo: view.bottomAnchor),
            bottomSheetViewTopConstraint
        ])
        // indicator
        NSLayoutConstraint.activate([
            indicatorView.widthAnchor.constraint(equalToConstant: 50),
            indicatorView.heightAnchor.constraint(equalToConstant: indicatorView.layer.cornerRadius * 2),
            indicatorView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            indicatorView.bottomAnchor.constraint(equalTo: bottomSheetView.topAnchor, constant: 14)
        ])
    }
    
//MARK: - show and hide BottomSheet

    private func showBottomSheet() {
        let safeAreaHeight: CGFloat = view.safeAreaLayoutGuide.layoutFrame.height
        let bottomPadding: CGFloat = view.safeAreaInsets.bottom
        
        bottomSheetViewTopConstraint.constant = (safeAreaHeight + bottomPadding) - defaultHeight
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
            self.dimmedView.alpha = 0.7
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func hideBottomSheet() {
        let safeAreaHeight = view.safeAreaLayoutGuide.layoutFrame.height
        let bottomPadding = view.safeAreaInsets.bottom
        bottomSheetViewTopConstraint.constant = safeAreaHeight + bottomPadding
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.dimmedView.alpha = 0.0
            self.view.layoutIfNeeded()
        }) { _ in
            if self.presentingViewController != nil {
                self.dismiss(animated: false, completion: nil)
            }
        }
    }
//MARK: - GestureRecognizer

    @objc func dimmedViewTapped(_ tapRecognizer : UITapGestureRecognizer) {
        hideBottomSheet()
    }
    @objc func bottomSheetViewPanned(_ panGestureRecognizer : UIPanGestureRecognizer){
        let translation = panGestureRecognizer.translation(in: bottomSheetView)
        let velocity = panGestureRecognizer.velocity(in: bottomSheetView)
        
        switch panGestureRecognizer.state {
        case .began :
            bottomSheetPanStartingTopConstant = bottomSheetViewTopConstraint.constant
        case .changed :
            
            bottomSheetViewTopConstraint.constant = bottomSheetPanStartingTopConstant + translation.y > bottomSheetPanStartingTopConstant ? bottomSheetPanStartingTopConstant + translation.y : bottomSheetPanStartingTopConstant
        case .ended:
            if bottomSheetView.frame.height > bottomSheetPanStartingTopConstant * 0.125{
                UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {                    self.bottomSheetViewTopConstraint.constant = self.bottomSheetPanStartingTopConstant
                    self.view.layoutIfNeeded()
                }, completion: nil)

            } else{
                hideBottomSheet()
                return
            }
            if velocity.y > 1500 {
                hideBottomSheet()
                return
            }
        default :
            break
        }
    
    }
}
 
