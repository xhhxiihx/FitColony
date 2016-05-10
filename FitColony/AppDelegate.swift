//
//  AppDelegate.swift
//  FitColony
//
//  Created by 李方然 on 16/3/7.
//  Copyright © 2016年 li. All rights reserved.
//

import UIKit
import AVOSCloud

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?


    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        HDprofile.registerSubclass()
        HDsport.registerSubclass()
        HDsleep.registerSubclass()
        NPrecord.registerSubclass()
        UserProfile.registerSubclass()
        FCHealthCircle.registerSubclass()
        FCUserHealthCircle.registerSubclass()
        FCHealthCircleTwitter.registerSubclass()
        
        hourformat.dateFormat="HH:mm"
        dayformat.dateFormat="yyyy-MM-dd"
        dateformat.dateFormat="yyyy-MM-dd HH:mm"
        weekdayformat.dateFormat="MMM dd"
        sleepformat.dateFormat="HH"
        
        AVOSCloud.setApplicationId("WiSF4icc4eDKJPWdIxCpPMJH-gzGzoHsz", clientKey: "ueiLRTEmhj4KByQtwxfVtdub")
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

