//
//  TRCollectionVC.swift
//  TopicRun
//
//  Created by 조성산 on 2022/07/28.
//

import Foundation
import UIKit

class CollectionVC: UIViewController {
    let data = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet var TopicImage: UIImageView!
    @IBOutlet weak var CollectionArea: UIView!
    
    
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
    override func viewWillAppear(_ animated: Bool) {
        let keyword = data.persistentContainer.savedEntities[0].keyword
        let topic = data.persistentContainer.savedEntities[0].topic
        let date = data.persistentContainer.savedEntities[0].date
        let runtime = data.persistentContainer.savedEntities[0].runtime
        let trial = data.persistentContainer.savedEntities[0].index
        
        let currentDate = Date()
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let str = dateFormatter.string(from: date!)
        
        var daysCount:Int = 0
        
        daysCount = days(from: date!)

        func days(from date: Date) -> Int {
            return calendar.dateComponents([.day], from: date, to: currentDate).day! + 1
        }
        
        
        
        TopicTitle.text = topic
        TopicHashTage.text = keyword
        StartDate.text = str
        RunTime.text = String(daysCount)
        WalkTime.text = runtime
        TopicTrial.text = String(trial)
    }
    
    @IBAction func AddTopicButton(_ sender: Any) {
    }
    
}

@IBDesignable extension UIView {
    @IBInspectable var shadowRadius: CGFloat {
        get { return layer.shadowRadius }
        set { layer.shadowRadius = newValue }
    }

    @IBInspectable var shadowOpacity: CGFloat {
        get { return CGFloat(layer.shadowOpacity) }
        set { layer.shadowOpacity = Float(newValue) }
    }

    @IBInspectable var shadowOffset: CGSize {
        get { return layer.shadowOffset }
        set { layer.shadowOffset = newValue }
    }

    @IBInspectable var shadowColor: UIColor? {
        get {
            guard let cgColor = layer.shadowColor else {
                return nil
            }
            return UIColor(cgColor: cgColor)
        }
        set { layer.shadowColor = newValue?.cgColor }
    }
}

