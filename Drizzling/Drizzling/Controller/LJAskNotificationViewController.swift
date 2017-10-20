//
//  LJAskNotificationViewController.swift
//  Drizzling
//
//  Created by longjianjiang on 2017/10/19.
//  Copyright © 2017年 Jiang. All rights reserved.
//

import UIKit
import UserNotifications

class LJAskNotificationViewController: UIViewController {
    @IBOutlet weak var msgLabel: UILabel!
    
    @IBOutlet weak var yesBtn: UIButton!
    @IBOutlet weak var noBtn: UIButton!
    
    @IBAction func didClickBtn(_ sender: UIButton) {
        let defaults = UserDefaults.standard
        
        if sender == yesBtn {
            AppDelegate.askNotification()
        }
        
        defaults.setValue(LJConstants.UserDefaultsValue.chooseNotification, forKey: LJConstants.UserDefaultsKey.askNotification)
        view.window?.rootViewController = LJCityListViewController()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        msgLabel.numberOfLines = 0
        msgLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        msgLabel.text = "Allow us to access notifications so we can alert you to the weather condition everyday"
        
        yesBtn.layer.cornerRadius = 20
        yesBtn.layer.borderWidth = 1.0
        yesBtn.layer.borderColor = UIColor.white.cgColor
        yesBtn.setTitle("Sounds great", for: .normal)
        
        noBtn.setTitle("No, thanks", for: .normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
