//
//  UserProfile.swift
//  FitColony
//
//  Created by 李方然 on 16/3/31.
//  Copyright © 2016年 li. All rights reserved.
//

import Foundation
import AVOSCloud

class UserProfile:AVObject,AVSubclassing{
    
    @NSManaged var user:AVUser
    @NSManaged var name:String
    @NSManaged var area:String
    @NSManaged var brief:String
    @NSManaged var avartar:AVFile?
    
    class func parseClassName() -> String! {
        return "UserProfile"
    }
    
    override init(){
        super.init()
    }
}