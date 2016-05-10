//
//  FCHealthCircle.swift
//  FitColony
//
//  Created by 李方然 on 16/5/8.
//  Copyright © 2016年 li. All rights reserved.
//

import Foundation
import AVOSCloud

class FCHealthCircle:AVObject,AVSubclassing{
    
    @NSManaged var circleName:String
    @NSManaged var circleNumber:String
    @NSManaged var circlePassword:String
    
    class func parseClassName() -> String! {
        return "FCHealthCircle"
    }
    
    override init(){
        super.init()
    }
}