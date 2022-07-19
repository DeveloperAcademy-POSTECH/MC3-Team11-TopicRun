//
//  StartPageViewController.swift
//  TopicRun
//
//  Created by Shin yongjun on 2022/07/19.
//

import Foundation
import UIKit

class StartPageViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var NicknameTextField: UITextField!
    @IBOutlet weak var topicRunButton: UIButton!
    
    override func viewDidLoad() {
        
        NicknameTextField.delegate = self
        topicRunButton.isEnabled = false
        topicRunButton.alpha = 0.5
    }
    
    
    @IBAction func topicRunButtonPressed(_ sender: UIButton) {
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text = (NicknameTextField.text! as NSString).replacingCharacters(in: range, with: string)
        if text.isEmpty {
            topicRunButton.isEnabled = false
            topicRunButton.alpha = 0.5
        } else {
            topicRunButton.isEnabled = true
            topicRunButton.alpha = 1.0
        }
        return true
    }
}
