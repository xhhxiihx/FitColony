//
//  FCDelegate.swift
//  FitColony
//
//  Created by 李方然 on 16/3/8.
//  Copyright © 2016年 li. All rights reserved.
//

import Foundation
import UIKit
public protocol ChooseSportDelegate{
    func choosesport()
}

public protocol refreshcalenderDelegate{
    func refreshcalender()
    func refreshtable()
}

public protocol refreshUserProfile{
    func refreshAvatar(avatar:UIImage)
    func refreshName(name:String)
    func refreshArea(area:String)
    func refreshBrief(brief:String)
    func refreshEmail(email:String)
}

public protocol getProfileDelegate{
    func getProfile()
}

public protocol refreshMyCircleDelegate{
    func refreshMyCircle()
}

