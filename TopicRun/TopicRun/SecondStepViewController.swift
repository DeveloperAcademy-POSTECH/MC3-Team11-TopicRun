//
//  SecondStepViewController.swift
//  TopicRun
//
//  Created by DongKyu Kim on 2022/08/02.
//

import UIKit

class SecondStepViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func actionButtonTapped(_ sender: UIButton) {
        if let pageController = parent as? OnBoardingViewController {
                pageController.pushNext()
            }
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
