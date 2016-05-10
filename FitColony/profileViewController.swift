//
//  basicViewController.swift
//  FitColony
//
//  Created by 李方然 on 16/3/10.
//  Copyright © 2016年 li. All rights reserved.
//



import UIKit
import AVOSCloud
class profileViewController: UIViewController {
    
    var user=AVUser.currentUser()
    
    @IBOutlet weak var circle1: CircleView!
    @IBOutlet weak var label: UICountingLabel!
    @IBOutlet weak var bMIlabel: UILabel!
    
    @IBOutlet weak var circle2: CircleView!
    @IBOutlet weak var bfratecount: UICountingLabel!
    @IBOutlet weak var bfratelabel: UILabel!
    
    @IBOutlet weak var heightcircle: CircleView!
    @IBOutlet weak var heightcount: UICountingLabel!
    @IBOutlet weak var heightlabel: UILabel!
    
    @IBOutlet weak var weightcircle: CircleView!
    @IBOutlet weak var weightcount: UICountingLabel!
    @IBOutlet weak var weightlabel: UILabel!
    

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let data=seledata()
        let rate=(22-abs(data.bMI-22))/22
        let greenrate=CGFloat(rate)
        
        var bfrateitem:Double {
            if data.sex{
                return 10
            }else{
                return 20
            }
        }
        
        let bfrate=(60-abs(data.bfr-10))/60
        let greenbfrate=CGFloat(bfrate)
        
        var heightitem:Double {
            if data.sex{
                return 180
            }else{
                return 160
            }
        }
        var weightitem:Double {
            if data.sex{
                return 65
            }else{
                return 45
            }
        }
        let hrate=(heightitem-abs(data.height-heightitem))/heightitem
        
        let wrate=(weightitem-abs(data.weight-weightitem))/weightitem
        
        
        circle1.clear()
        self.show(circle1,countlabel:label,label:bMIlabel,value:data.bMI,r:70,greenrate: greenrate)
        circle2.clear()
        self.show(circle2,countlabel: bfratecount,label: bfratelabel,value:data.bfr,r:80,greenrate: greenbfrate)
        heightcircle.clear()
        self.show(heightcircle,countlabel:heightcount,label:heightlabel,value:data.height,r:60,greenrate: CGFloat(hrate))
        weightcircle.clear()
        self.show(weightcircle,countlabel:weightcount,label:weightlabel,value:data.weight,r:60,greenrate: CGFloat(wrate))
        
    }
    
    func seledata()->(height:Double,weight:Double,bMI:Double,bfr:Double,sex:Bool){
        
        let sele=HDprofile.query()
        sele.whereKey("user", equalTo: AVUser.currentUser())
        let profile=sele.getFirstObject() as! HDprofile
        var sex:Bool{
            if profile.sex=="male"{
                return true
            }else{
                return false
            }
        }
        return (profile.height,profile.weight,profile.bMI,profile.bodyfatrate,sex)
        
    }
    

    
    func show(circle:CircleView,countlabel:UICountingLabel,label:UILabel,value:Double,r:CGFloat,greenrate:CGFloat){
        let redrate=1-greenrate
        circle.configure(greenrate,endcolor:UIColor(red: redrate, green: greenrate, blue: 0/255, alpha: 1.0).CGColor,endalphacolor: UIColor(red: redrate, green: greenrate, blue: 0/255, alpha: 0.4).CGColor,r:r)
        countlabel.countFrom(0.0, endValue: CGFloat(value), duration: 1)
        UIView.animateWithDuration(1) { () -> Void in
            countlabel.textColor=UIColor(red: redrate, green: greenrate, blue: 0/255, alpha: 1.0)
            label.textColor=UIColor(red: redrate, green: greenrate, blue: 0/255, alpha: 1.0)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        circle1.frame.size.height = 210.0
        circle1.frame.size.width = 210.0
        circle2.frame.size.height = 240.0
        circle2.frame.size.width = 240.0
        heightcircle.frame.size=CGSize(width: 180,height: 180)
        weightcircle.frame.size=CGSize(width: 180,height: 180)

        self.label.textColor=UIColor.greenColor()
        self.bMIlabel.textColor=UIColor.greenColor()
        self.heightlabel.textColor=UIColor.greenColor()
        self.weightlabel.textColor=UIColor.greenColor()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
   