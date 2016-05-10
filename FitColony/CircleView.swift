//
//  CircleView.swift
//  FitColony
//
//  Created by 李方然 on 16/3/21.
//  Copyright © 2016年 li. All rights reserved.
//

import UIKit

class CircleView: UIView {
    let π = CGFloat(M_PI)
    var prevValue : CGFloat = 0.0
   
    var circleLayer: CAShapeLayer?
    var thincircleLayer: CAShapeLayer?

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    func clear(){
        
      
        self.circleLayer?.removeFromSuperlayer()
        self.thincircleLayer?.removeFromSuperlayer()
    }
    
    func configure(end:CGFloat,endcolor:CGColor,endalphacolor:CGColor,r:CGFloat) {
        
        
        let startAngle = 1.5*π
        let endAngle = 3.5*π
        let ovalRect = CGRectMake(r, r, r, r)
        
        let ovalPath = UIBezierPath(arcCenter: CGPointMake(CGRectGetMidX(ovalRect), CGRectGetMidY(ovalRect)), radius: CGRectGetWidth(ovalRect), startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        let circleLayer = CAShapeLayer()
        circleLayer.path = ovalPath.CGPath
        circleLayer.fillColor = UIColor.clearColor().CGColor
        circleLayer.lineWidth = 10.0
        circleLayer.lineCap = kCALineJoinMiter
        
        let thincircleLayer = CAShapeLayer()
        thincircleLayer.path = ovalPath.CGPath
        thincircleLayer.fillColor = UIColor.clearColor().CGColor
        thincircleLayer.lineWidth = 5.0
        thincircleLayer.lineCap = kCALineJoinMiter
        
        
        self.circleLayer = circleLayer
        self.thincircleLayer = thincircleLayer
        
        self.layer.addSublayer(self.thincircleLayer!)
        self.layer.addSublayer(self.circleLayer!)
        
        self.circleLayer!.strokeStart = 0.0
        
    
        //Initial stroke-
        setStrokeEndForLayer(0.0,  to: end,fromcolor:UIColor.redColor().CGColor,tocolor:endcolor,fromalphacolor: UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 0.5).CGColor,toalphacolor: endalphacolor, animated: true)

    }
    
    func setStrokeEndForLayer(from:CGFloat, to: CGFloat,fromcolor:CGColor,tocolor:CGColor,fromalphacolor:CGColor,toalphacolor:CGColor, animated: Bool)
    {
        let duration:Double=1.0
        
        
        if animated
        {
            let anim = CABasicAnimation(keyPath: "strokeEnd")
            // here i set the duration
            anim.fromValue = from
            anim.toValue = to
            
            let animcolor = CABasicAnimation(keyPath: "strokeColor")
            animcolor.fromValue=fromcolor
            animcolor.toValue=tocolor
            
            let animG=CAAnimationGroup()
            animG.animations=[anim,animcolor]
            animG.duration=duration
            animG.removedOnCompletion = false
            animG.fillMode = kCAFillModeForwards
            
            let animcoloralpha = CABasicAnimation(keyPath: "strokeColor")
            animcoloralpha.fromValue=fromalphacolor
            animcoloralpha.toValue=toalphacolor
            animcoloralpha.duration=duration
            animcoloralpha.removedOnCompletion = false
            animcoloralpha.fillMode = kCAFillModeForwards
            
            self.circleLayer!.addAnimation(animG, forKey: nil)
            self.thincircleLayer!.addAnimation(animcoloralpha, forKey: nil)
            
        }
    }

    
    
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}


