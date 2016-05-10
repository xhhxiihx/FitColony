//
//  Publicdateformat.swift
//  FitColony
//
//  Created by 李方然 on 16/3/15.
//  Copyright © 2016年 li. All rights reserved.
//

import Foundation

public let hourformat=NSDateFormatter()

public let dayformat=NSDateFormatter()

public let dateformat=NSDateFormatter()

public let weekdayformat=NSDateFormatter()

public let sleepformat=NSDateFormatter()

public func delay(delay:Double, closure:()->()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(), closure)
}

