//
//  LJConst.swift
//  Drizzling
//
//  Created by longjianjiang on 2017/10/19.
//  Copyright © 2017年 Jiang. All rights reserved.
//

import UIKit

struct LJConstants {
    static let kScreenWidth = UIScreen.main.bounds.size.width
    static let kScreenHeight = UIScreen.main.bounds.size.height
    
    static let themeColor = UIColor(red: 153/255.0, green: 153/255.0, blue: 153/255.0, alpha: 1.0)
    
    struct UserDefaultsKey {
        static let unit = "kUnit"
        static let askLocation = "kAskLocation"
        static let askNotification = "kAskNotification"
    }
    
    struct UserDefaultsValue {
        static let fahrenheitUnit = "kFahrenheitUnit"
        static let celsiusUnit = "kelsiusUnit"
        
        static let chooseLocation = "kChooseLocation"
        static let chooseNotification = "kChooseNotification"
    }
    
    struct RuntimePropertyKey {
        static let kHighlightStrKey = UnsafePointer<Any>.init(bitPattern: "kHighlightStrKey".hashValue)
        static let kHightlightStrTapActionKey = UnsafePointer<Any>.init(bitPattern: "kHightlightStrTapActionKey".hashValue)
    }
}

