//
//  UIViewController+FC.swift
//  FitColony
//
//  Created by 李方然 on 16/3/29.
//  Copyright © 2016年 li. All rights reserved.
//

import Foundation
import UIKit
extension UIViewController{
    
    func setTabBarVisible(visible:Bool, animated:Bool) {
        
//        //* This cannot be called before viewDidLayoutSubviews(), because the frame is not set before this time
//        
//        // bail if the current state matches the desired state
//        if (tabBarIsVisible() == visible) { return }
//        
//        // get a frame calculation ready
//        let frame = self.tabBarController?.tabBar.frame
//        let height = frame?.size.height
//        let offsetY = (visible ? -height! : height)
//        
//        // zero duration means no animation
//        let duration:NSTimeInterval = (animated ? 0.3 : 0.0)
//        
//        //  animate the tabBar
//        if frame != nil {
//            UIView.animateWithDuration(duration) {
//                self.tabBarController?.tabBar.frame = CGRectOffset(frame!, 0, offsetY!)
//                return
//            }
//        }
    }
    
    func tabBarIsVisible() ->Bool {
        return self.tabBarController?.tabBar.frame.origin.y < CGRectGetMaxY(self.view.frame)
    }
    
    // Call the function from tap gesture recognizer added to your view (or button)
    
}