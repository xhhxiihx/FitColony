//
//  TableViewCell.swift
//  FitColony
//
//  Created by 李方然 on 16/3/15.
//  Copyright © 2016年 li. All rights reserved.
//


import UIKit
import AVOSCloud
class sportrecordTableViewCell:UITableViewCell{
    @IBOutlet weak var duration:UILabel!
}


class circleheadTableViewCell:UITableViewCell{
    @IBOutlet weak var avartar: UIImageView!
}


class circleTwitterTableViewCell:UITableViewCell{

    
    var currentUser:AVUser?
    var circleTwitter:FCHealthCircleTwitter = FCHealthCircleTwitter()
    @IBAction func joinEvent(sender: AnyObject) {
        join.setTitle("已加入", forState: .Normal)
        join.setTitleColor(UIColor.grayColor(), forState: .Normal)
        if ((circleTwitter.participate?.contains(currentUser!)) == false){
            circleTwitter.participate?.append(currentUser!)
            circleTwitter.save()
            var count=String(circleTwitter.participate!.count)
            
            participateNumber.text = "共\(count)人参加了活动"
        }
    }
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var comment: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var user: UILabel!
    @IBOutlet weak var paticipateName: UILabel!
    @IBOutlet weak var participateNumber: UILabel!
    @IBOutlet weak var join: UIButton!
    
}