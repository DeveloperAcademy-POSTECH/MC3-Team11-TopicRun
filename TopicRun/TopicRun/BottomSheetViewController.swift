//
//  SheetViewController.swift
//  TopicRun
//
//  Created by 이규환 on 2022/07/18.
//

import UIKit

class BottomSheetViewController: UIViewController {
    
    var defaultHeight : CGFloat = 300
    
    private lazy var bottomSheetPanStartingTopConstant : CGFloat = bottomSheetViewTopConstraint.constant
    private let dimmedView : UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray.withAlphaComponent(0.7)
        return view
    }()

    private let bottomSheetView : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.clipsToBounds = true
        return view
    }()
    // 강제 언래핑
    private var bottomSheetViewTopConstraint : NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        let dimmedTap = UITapGestureRecognizer(target: self, action: #selector(dimmedViewTapped(_:)))
        dimmedView.addGestureRecognizer(dimmedTap)
        dimmedView.isUserInteractionEnabled = true
        
        let viewPan = UIPanGestureRecognizer(target: self, action: #selector(bottomSheetViewPanned(_:)))
        viewPan.delaysTouchesBegan = false
        viewPan.delaysTouchesEnded = false
        bottomSheetView.addGestureRecognizer(viewPan)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showBottomSheet()

    }
    
    
    private func setupUI(){
        view.addSubview(dimmedView)
        view.addSubview(bottomSheetView)
        dimmedView.alpha = 0.0
        setupLayout()
        
    }

    private func setupLayout(){
        dimmedView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dimmedView.topAnchor.constraint(equalTo: view.topAnchor),
            dimmedView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            dimmedView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dimmedView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        // 바텀시트오토레이아웃
        bottomSheetView.translatesAutoresizingMaskIntoConstraints = false
        //
        let topConstant = view.safeAreaInsets.bottom + view.safeAreaLayoutGuide.layoutFrame.height
        
        bottomSheetViewTopConstraint = bottomSheetView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: topConstant)
        
        NSLayoutConstraint.activate([
            bottomSheetViewTopConstraint,
            bottomSheetView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomSheetView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            bottomSheetView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    private func showBottomSheet(){
        let safeAreaHeight : CGFloat = view.safeAreaLayoutGuide.layoutFrame.height
        let bottomPadding : CGFloat = view.safeAreaInsets.bottom
        
        bottomSheetViewTopConstraint.constant = (safeAreaHeight + bottomPadding) - defaultHeight
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
            self.dimmedView.alpha = 0.7
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    private func hideBottomSheet(){
        let safeAreaHeight = view.safeAreaLayoutGuide.layoutFrame.height
        let bottomPadding = view.safeAreaInsets.bottom
        
        bottomSheetViewTopConstraint.constant = safeAreaHeight + bottomPadding
        
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
            self.dimmedView.alpha = 0.0
            self.view.layoutIfNeeded()
        }) { _ in
            if self.presentingViewController != nil {
                self.dismiss(animated: false, completion: nil)
            }
        }
    }
    
    @objc private func dimmedViewTapped(_ tapRecognizer : UITapGestureRecognizer) {
        hideBottomSheet()
    }
    
    @objc private func bottomSheetViewPanned(_ panGestureRecognizer : UIPanGestureRecognizer){
        let translation = panGestureRecognizer.translation(in: bottomSheetView)
        let velocity = panGestureRecognizer.velocity(in: bottomSheetView)
        
        switch panGestureRecognizer.state {
        case .began :
            bottomSheetPanStartingTopConstant = bottomSheetViewTopConstraint.constant
        case .changed :
            
            bottomSheetViewTopConstraint.constant = bottomSheetPanStartingTopConstant + translation.y > bottomSheetPanStartingTopConstant ? bottomSheetPanStartingTopConstant + translation.y : bottomSheetPanStartingTopConstant
            
            
        case .ended:
            if bottomSheetView.frame.height > 40{
                UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
                    self.bottomSheetViewTopConstraint.constant = self.bottomSheetPanStartingTopConstant
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
 
