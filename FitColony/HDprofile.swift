//
//  student.swift
//  FitColony
//
//  Created by 李方然 on 16/3/12.
//  Copyright © 2016年 li. All rights reserved.
//

import UIKit
import AVOSCloud



class HDprofile:AVObject,AVSubclassing{
    
    @NSManaged var height:Double
    @NSManaged var weight:Double
    @NSManaged var age:Double
    @NSManaged var sex:String
    @NSManaged var bustline:Double
    @NSManaged var waistline:Double
    @NSManaged var hipsline:Double
    @NSManaged var bMI:Double
    @NSManaged var bodyfatrate:Double
    @NSManaged var user:AVUser?
    
    
    class func parseClassName() -> String! {
        return "HDprofile"
    }
    override init(){
        super.init()
        
    }
}

