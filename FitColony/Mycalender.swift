//
//  Mycalender.swift
//  FitColony
//
//  Created by 李方然 on 16/3/21.
//  Copyright © 2016年 li. All rights reserved.
//

import Foundation
import CVCalendar
// MARK: Delete circle and dot views (in effect refreshing the dayView circle)

extension CVCalendarContentViewController {
    func removeCircleLabel(dayView: CVCalendarDayView) {
        for each in dayView.subviews {
            if each is UILabel {
                continue
            }
            else if each is CVAuxiliaryView  {
                continue
            }
            else {
                each.removeFromSuperview()
            }
        }
    }
}

//MARK: Delete dot views (in effect refreshing the dayView dots)

extension CVCalendarContentViewController {
    func removeDotViews(dayView: CVCalendarDayView) {
        for each in dayView.subviews {
            if each is CVAuxiliaryView && each.frame.height == 13 {
                each.removeFromSuperview()
            }
        }
    }
}