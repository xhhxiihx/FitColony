//
//  NPrecord.swift
//  FitColony
//
//  Created by 李方然 on 16/3/30.
//  Copyright © 2016年 li. All rights reserved.
//


import AVOSCloud



class NPrecord:AVObject,AVSubclassing{
    
    @NSManaged var event:String
    @NSManaged var isImportant:Bool
    @NSManaged var isNotified:Bool
    @NSManaged var notifiedcomment:String
    @NSManaged var notifiedAt:NSDate
    @NSManaged var from:AVUser?
    @NSManaged var to:AVUser?
    
    class func parseClassName() -> String! {
        return "NPrecord"
    }
    override init(){
        super.init()
    }
}