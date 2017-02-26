//
//  MyUtils.swift
//  Drizzling
//
//  Created by longjianjiang on 2017/2/26.
//  Copyright © 2017年 Jiang. All rights reserved.
//

import Foundation


// if the city's name is beijingshi, then delete shi
extension String{
    func transformToPinYin()->String{
        let mutableString = NSMutableString(string: self)
        CFStringTransform(mutableString, nil, kCFStringTransformToLatin, false)
        CFStringTransform(mutableString, nil, kCFStringTransformStripDiacritics, false)
        let string = String(mutableString).replacingOccurrences(of: " ", with: "")
        let index = string.index(string.endIndex, offsetBy: -3)
        return string.substring(to: index)
    }
}
