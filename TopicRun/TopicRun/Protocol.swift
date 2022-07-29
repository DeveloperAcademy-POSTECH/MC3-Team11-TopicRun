//
//  Protocol.swift
//  TopicRun
//
//  Created by 이규환 on 2022/07/20.
//

import Foundation
import UIKit


@objc protocol ContainsButton {
    func makeButtonView() -> UIView
    @objc func buttonClosed()
}
