//
//  SPORT.swift
//  FitColony
//
//  Created by 李方然 on 16/3/14.
//  Copyright © 2016年 li. All rights reserved.
//


import AVOSCloud





class HDsport:AVObject,AVSubclassing{
    
    
    @NSManaged var sportname:String
    @NSManaged var date:NSDate
    @NSManaged var startAt:NSDate
    @NSManaged var endAt:NSDate
    @NSManaged var duration:Double
    @NSManaged var comsumption:Double
    @NSManaged var user:AVUser?
    
    class func parseClassName() -> String! {
        return "HDsport"
    }
    override init(){
        super.init()
        
    }
}