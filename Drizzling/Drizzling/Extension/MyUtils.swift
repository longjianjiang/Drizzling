//
//  MyUtils.swift
//  Drizzling
//
//  Created by longjianjiang on 2017/2/26.
//  Copyright © 2017年 Jiang. All rights reserved.
//

import Foundation
import UIKit
import CoreText

// if the city's name is beijingshi, then delete shi
extension String  {
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
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        gradientLayer.locations = [0.4, 1]
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

extension UILabel {
    
    private var hightlightStr: String? {
        get {
            return objc_getAssociatedObject(self, LJConstants.RuntimePropertyKey.kHighlightStrKey!) as? String
        }
        
        set {
            objc_setAssociatedObject(self, LJConstants.RuntimePropertyKey.kHighlightStrKey!, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    private var highlightStrTapAction: (() -> Void)? {
        get {
            return objc_getAssociatedObject(self, LJConstants.RuntimePropertyKey.kHightlightStrTapActionKey!) as? (() -> Void)
        }
        
        set {
            objc_setAssociatedObject(self, LJConstants.RuntimePropertyKey.kHightlightStrTapActionKey!, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    func boundingRectForCharacterRange(range: NSRange) -> CGRect? {
        
        guard let attributedText = attributedText else { return nil }
        
        let textStorage = NSTextStorage(attributedString: attributedText)
        let layoutManager = NSLayoutManager()
        
        textStorage.addLayoutManager(layoutManager)
        
        let textContainer = NSTextContainer(size: bounds.size)
        textContainer.lineFragmentPadding = 0.0
        
        layoutManager.addTextContainer(textContainer)
        
        var glyphRange = NSRange()
        var lineRange = NSRange()
        
        
        // Convert the range for glyphs.
        layoutManager.characterRange(forGlyphRange: range, actualGlyphRange: &glyphRange)
    
        let highlightStartRect = layoutManager.lineFragmentUsedRect(forGlyphAt: glyphRange.location, effectiveRange: &lineRange)
        let highlightEndRect = layoutManager.lineFragmentRect(forGlyphAt: glyphRange.location, effectiveRange: &lineRange)
        
        print("highlightStartRect :  \(highlightStartRect)")
        print("highlightEndRect : \(highlightEndRect)")
        
        print(layoutManager.boundingRect(forGlyphRange: glyphRange, in: textContainer))
        return layoutManager.boundingRect(forGlyphRange: glyphRange, in: textContainer)
        
    }
    
    func getLineBounds(line: UnsafeRawPointer, point: CGPoint) -> CGRect {
        var ascent: CGFloat = 0
        var descent: CGFloat = 0
        var leading: CGFloat = 0
        let lineRef = unsafeBitCast(line,to: CTLine.self)
        let width = (CGFloat)(CTLineGetTypographicBounds(lineRef, &ascent, &descent, &leading))
        let height = ascent + fabs(descent) + leading
        return CGRect(x: point.x, y: point.y, width: width, height: height)
    }
    
    func isTouchInHighlightArea(point: CGPoint) -> Bool {
        let frameSetter = CTFramesetterCreateWithAttributedString(attributedText!)
        var path = CGMutablePath()
        path.addRect(CGRect(x: 0, y: 0, width: bounds.size.width, height: bounds.size.height))
        var frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, nil)
        let range = CTFrameGetVisibleStringRange(frame)
        
        if (attributedText?.length)! > range.length {
            print("______")
            var m_font : UIFont
            let n_font = self.attributedText?.attribute(NSAttributedStringKey.font, at: 0, effectiveRange: nil)
            if n_font != nil {
                m_font = n_font as! UIFont
            }else if (self.font != nil) {
                m_font = self.font!
            }else {
                m_font = UIFont.systemFont(ofSize: 17)
            }
            
            path = CGMutablePath()
            path.addRect(CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height + m_font.lineHeight), transform: CGAffineTransform.identity)
            
            frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, nil)
            
        } else {
            print("++++++")
        }
        let lines = CTFrameGetLines(frame)
        let lineCount = CFArrayGetCount(lines)
        
        if lineCount < 1 {
            return false
        }
        
        var origins = CGPoint()
        let lineOrigins = withUnsafeMutablePointer(to: &origins) { $0 }
        CTFrameGetLineOrigins(frame, CFRangeMake(0, 0), lineOrigins)
        
        let transform = CGAffineTransform(translationX: 0, y: bounds.height).scaledBy(x: 1.0, y: -1.0)
        
        for i in 0..<lineCount {
            let linePoint = lineOrigins[i]
            let line = CFArrayGetValueAtIndex(lines, i)
            let flippedRect = getLineBounds(line: line!, point: linePoint)
            var rect = flippedRect.applying(transform)
            rect = rect.insetBy(dx: 0, dy: 0)
            rect = rect.offsetBy(dx: 0, dy: 0)
            let style = attributedText?.attribute(NSAttributedStringKey.paragraphStyle, at: 0, effectiveRange: nil) as? NSParagraphStyle
            let lineSpace: CGFloat
            
            if let style = style {
                lineSpace = style.lineSpacing
            } else {
                lineSpace = 0
            }
            
            let lineOutSpace: CGFloat = (bounds.height - lineSpace * (CGFloat)(lineCount - 1) - rect.height * (CGFloat)(lineCount)) / 2.0
            rect.origin.y = lineOutSpace + rect.height * (CGFloat)(i) + lineSpace * (CGFloat)(i)
            
            if rect.contains(point) {
                let relativePoint = CGPoint(x: point.x - rect.minX,
                                            y: point.y - rect.minY)
                let lineRef = unsafeBitCast(line,to: CTLine.self)
                var index = CTLineGetStringIndexForPosition(lineRef, relativePoint)
                var offset: CGFloat = 0
                
                CTLineGetOffsetForStringIndex(lineRef, index, &offset)
                if offset > relativePoint.x {
                    index = index - 1
                }
                let range = text?.range(of: hightlightStr!)
                
                
                let highlightRange = NSRange(range!, in: text!) //text?.range(of: hightlightStr!)?.nsRange
                if NSLocationInRange(index, highlightRange) {
                    return true
                }
            }
        }
        
        return false
    }
    
    func setFont(_ size: CGFloat, text: String, hightlight: String, highlightTapAction: @escaping (() -> Void)) {
        hightlightStr = hightlight
        highlightStrTapAction = highlightTapAction
        
        isUserInteractionEnabled = true
        let font = UIFont(name: "Helvetica", size:size)
        let attributedStr = NSMutableAttributedString(string: text, attributes: [
            NSAttributedStringKey.font: font!,
            NSAttributedStringKey.foregroundColor: UIColor.black])
        
        let range = text.range(of: hightlight)
        attributedStr.setAttributes([
            NSAttributedStringKey.foregroundColor: UIColor.blue], range: (range?.nsRange)!)
        
        attributedText = attributedStr
    }

    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let point = touch?.location(in: self)
        
        if isTouchInHighlightArea(point: point!) {
            highlightStrTapAction!()
        }
    }
}


