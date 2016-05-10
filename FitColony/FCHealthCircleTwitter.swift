//
//  FCHealthCircleTwitter.swift
//  FitColony
//
//  Created by 李方然 on 16/5/8.
//  Copyright © 2016年 li. All rights reserved.
//

import Foundation
import AVOSCloud

class FCHealthCircleTwitter:AVObject,AVSubclassing{
    
    @NSManaged var user:AVUser
    @NSManaged var circle:FCHealthCircle
    @NSManaged var date:NSDate
    @NSManaged var event:String
    @NSManaged var comment:String
    @NSManaged var participate:[AVUser]?
    
    class func parseClassName() -> String! {
        return "FCHealthCircleTwitter"
    }
    
    override init(){
        super.init()
    }
}