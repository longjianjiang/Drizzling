//
//  LJChooseTemperatureUnitViewController.swift
//  Drizzling
//
//  Created by longjianjiang on 2017/2/8.
//  Copyright © 2017年 Jiang. All rights reserved.
//

import UIKit

class LJChooseTemperatureUnitViewController: UIViewController {
    
    @IBOutlet weak var msgLabel: UILabel!
    @IBOutlet weak var celsiusBtn: UIButton!
    @IBOutlet weak var fahrenheitBtn: UIButton!
 
    
    @IBAction func didClickBtn(_ sender: UIButton) {
        let defaults = UserDefaults.standard

        if sender == fahrenheitBtn {
            defaults.set("fahrenheit", forKey: "unit")
            defaults.synchronize()
        } else if sender == celsiusBtn {
            defaults.set("celsius", forKey: "unit")
            defaults.synchronize()
        }
        
        self.view.window?.rootViewController = ViewController()
    }
    
    func getSuperAttibutedSring(_ string: NSString, and superString: String) -> NSMutableAttributedString {
        let font:UIFont? = UIFont(name: "Helvetica", size:15)
        let fontSuper:UIFont? = UIFont(name: "Helvetica", size:10)
        let attString:NSMutableAttributedString = NSMutableAttributedString(string: string as String, attributes: [NSFontAttributeName:font!,NSForegroundColorAttributeName:UIColor.white])
        let range = string.range(of: superString)
        attString.setAttributes([NSFontAttributeName:fontSuper!,NSBaselineOffsetAttributeName:10,NSForegroundColorAttributeName:UIColor.white], range: range)
        return attString
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        msgLabel.numberOfLines = 0
        msgLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        msgLabel.text = "Which units would you like the\nweather to show"
       
        fahrenheitBtn.layer.cornerRadius = 20
        fahrenheitBtn.layer.borderWidth = 1.0
        fahrenheitBtn.layer.borderColor = UIColor.white.cgColor
        fahrenheitBtn.setAttributedTitle(getSuperAttibutedSring("FAHRENHEIT oF", and: "o"), for: .normal)
        
        celsiusBtn.layer.cornerRadius = 20
        celsiusBtn.layer.borderWidth = 1.0
        celsiusBtn.layer.borderColor = UIColor.white.cgColor
        celsiusBtn.setAttributedTitle(getSuperAttibutedSring("CELSIUS oC", and: "o"), for: .normal)
    }

    
    deinit {
        print("choose VC dealloc")
    }
}
