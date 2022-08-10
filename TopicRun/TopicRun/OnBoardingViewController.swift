//
//  OnBoardingViewController.swift
//  TopicRun
//
//  Created by DongKyu Kim on 2022/08/01.
//

import UIKit

class OnBoardingViewController: UIPageViewController {
    // MARK: - UI Elements
    private var viewControllerList: [UIViewController] = {
        let storyboard = UIStoryboard.onboarding
        let firstVC = storyboard.instantiateViewController(withIdentifier: "FirstStepVC")
        let secondVC = storyboard.instantiateViewController(withIdentifier: "SecondStepVC")
        let thirdVC = storyboard.instantiateViewController(withIdentifier: "ThirdStepVC")
        let fourthVC = storyboard.instantiateViewController(withIdentifier: "FourthStepVC")
        let startNavigationVC = storyboard.instantiateViewController(withIdentifier: "startNavigationVC")
        return [firstVC, secondVC, thirdVC, fourthVC, startNavigationVC]
    }()
    
    // MARK: - Properties
    private var currentIndex = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setViewControllers([viewControllerList[0]], direction: .forward, animated: false, completion: nil)
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    func pushNext() {
        if currentIndex + 1 < viewControllerList.count {
            self.setViewControllers([self.viewControllerList[self.currentIndex + 1]], direction: .forward, animated: true, completion: nil)
            currentIndex += 1
        }
    }

    
    
}

extension UIStoryboard {
    static let onboarding = UIStoryboard(name: "StartPageView", bundle: nil)
    static let main = UIStoryboard(name: "Main", bundle: nil)
}
