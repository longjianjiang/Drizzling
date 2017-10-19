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
            defaults.set(LJConstants.UserDefaultsValue.fahrenheitUnit, forKey: LJConstants.UserDefaultsKey.unit)
        } else if sender == celsiusBtn {
            defaults.set(LJConstants.UserDefaultsValue.celsiusUnit, forKey: LJConstants.UserDefaultsKey.unit)
        }
        
        view.window?.rootViewController = LJAskUseLocationViewController()
    }
   
    func getSuperAttibutedSring(_ string: String, and superString: String) -> NSMutableAttributedString {
        let font = UIFont(name: "Helvetica", size:15)
        let fontSuper = UIFont(name: "Helvetica", size:10)
        let attributedStr = NSMutableAttributedString(string: string, attributes: [
            NSAttributedStringKey.font: font!,
            NSAttributedStringKey.foregroundColor: UIColor.white])

        let range = string.range(of: superString)
        attributedStr.setAttributes([
            NSAttributedStringKey.font: fontSuper!,
            NSAttributedStringKey.baselineOffset: 10,
            NSAttributedStringKey.foregroundColor: UIColor.white], range: (range?.nsRange)!)
        
        return attributedStr
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


