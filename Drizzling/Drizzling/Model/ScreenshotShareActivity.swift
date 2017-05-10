//
//  ScreenshotShareActivity.swift
//  Drizzling
//
//  Created by longjianjiang on 2017/5/10.
//  Copyright © 2017年 Jiang. All rights reserved.
//

import UIKit

class ScreenshotShareActivity: UIActivity {
    
    var completionHandler: ()->Void = {}
    
    override var activityType: UIActivityType? {
        return UIActivityType.init("Screenshot Share")
    }
    
    override var activityTitle: String? {
        return "Screenshot Share"
    }
    
    var _activityImage: UIImage? { // if override , then the image will not be displayed correctly
        return UIImage.init(named: "Group")
    }
    
    override func perform() {
        self.activityDidFinish(true)
        
        completionHandler()

    }
    
    override func canPerform(withActivityItems activityItems: [Any]) -> Bool {
        if activityItems.count > 0 {
            return true
        }
        return false
    }
}
