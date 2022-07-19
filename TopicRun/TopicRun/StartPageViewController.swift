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
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        self.view.endEditing(true)
        return true
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
}
