////
////  NavigationBarHeight.swift
////  FitColony
////
////  Created by 李方然 on 16/3/19.
////  Copyright © 2016年 li. All rights reserved.
////
//
import Foundation
import UIKit

class TallerNaviBar: UINavigationBar {
    override func sizeThatFits(size: CGSize) -> CGSize {
        let newSize:CGSize = CGSizeMake(self.superview!.frame.size.width, 70)
        return newSize
    }
}