//
//  MyUtils.swift
//  Drizzling
//
//  Created by longjianjiang on 2017/2/26.
//  Copyright © 2017年 Jiang. All rights reserved.
//

import Foundation
import UIKit

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

extension CAGradientLayer {
    static func gradientLayer(with gradient: Gradient) -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [gradient.startColor.cgColor, gradient.endColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0);
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1);
        gradientLayer.locations = [0.4, 1];
        return gradientLayer
    }
}

extension Range where Bound == String.Index {
    var nsRange:NSRange {
        return NSRange(location: self.lowerBound.encodedOffset,
                       length: self.upperBound.encodedOffset -
                        self.lowerBound.encodedOffset)
    }
}
