//
//  Protocol.swift
//  TopicRun
//
//  Created by 이규환 on 2022/07/20.
//

import Foundation
import UIKit


@objc protocol ContainsButton : AnyObject{
    func makeButtonView() -> UIButton
    @objc func buttonClosed()
}

//protocol Draggable{
//    @objc func dragClosd()
//}
