//
//  TRCollectionVC.swift
//  TopicRun
//
//  Created by 조성산 on 2022/07/28.
//

import Foundation
import UIKit

class CollectionVC: UIViewController {
    @IBOutlet weak var CollectionArea: UIView!
    @IBOutlet weak var TopicImage: UIImageView!
    
    @IBOutlet weak var RunTime: UILabel!
    @IBOutlet weak var StartDate: UILabel!
    @IBOutlet weak var WalkTime: UILabel!
    @IBOutlet weak var TopicTrial: UILabel!
    
    @IBOutlet var TopicTitle: UILabel!
    @IBOutlet var TopicHashTage: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TopicImage.layer.masksToBounds = true
        TopicImage.layer.cornerRadius = 15
        TopicImage.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMinXMinYCorner)
        
        TopicImage.layer.shadowOffset = CGSize(width: 5, height: 5)
        TopicImage.layer.shadowOpacity = 0.7
        TopicImage.layer.shadowRadius = 5
        TopicImage.layer.shadowColor = UIColor.gray.cgColor
        
        CollectionArea.layer.masksToBounds = true
        CollectionArea.layer.cornerRadius = 15
        CollectionArea.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMaxXMinYCorner, .layerMaxXMaxYCorner)
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func AddTopicButton(_ sender: Any) {
    }
    
}
