//
//  FCUserHealthCircle.swift
//  FitColony
//
//  Created by 李方然 on 16/5/8.
//  Copyright © 2016年 li. All rights reserved.
//

import Foundation
import AVOSCloud

class FCUserHealthCircle:AVObject,AVSubclassing{
    
    @NSManaged var user:AVUser
    @NSManaged var circle:FCHealthCircle
    
    
    
    class func parseClassName() -> String! {
        return "FCUserHealthCircle"
    }
    
    override init(){
        super.init()
    }
}