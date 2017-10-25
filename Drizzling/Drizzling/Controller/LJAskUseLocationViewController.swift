//
//  LJAskUseLocationViewController.swift
//  Drizzling
//
//  Created by longjianjiang on 2017/10/19.
//  Copyright © 2017年 Jiang. All rights reserved.
//

import UIKit
import MapKit

class LJAskUseLocationViewController: UIViewController {
    
    @IBOutlet weak var msgLabel: UILabel!
    @IBOutlet weak var yesBtn: UIButton!
    @IBOutlet weak var noBtn: UIButton!
    
    @IBAction func didClickBtn(_ sender: UIButton) {
        let defaults = UserDefaults.standard
        
        if sender == yesBtn {
            LJLocationManager.shared.askLocation()
            LJLocationManager.shared.authorizationDelegate = self
        } else {
            view.window?.rootViewController = LJAskNotificationViewController()
        }
        
        defaults.setValue(LJConstants.UserDefaultsValue.chooseLocation, forKey: LJConstants.UserDefaultsKey.askLocation)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        msgLabel.numberOfLines = 0
        msgLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        msgLabel.text = "Allow us to access your location to give you hour-by-hour weather forecast"
        
        yesBtn.layer.cornerRadius = 20
        yesBtn.layer.borderWidth = 1.0
        yesBtn.layer.borderColor = UIColor.white.cgColor
        yesBtn.setTitle("Sounds great", for: .normal)
        
        noBtn.setTitle("No, thanks", for: .normal)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension LJAskUseLocationViewController: LJLocationManagerAuthorizationDelegate {
    func locationManager(_ manager: LJLocationManager, userDidChooseLocation status: CLAuthorizationStatus) {
        if status == .notDetermined {
            return
        }
        view.window?.rootViewController = LJAskNotificationViewController()
    }
}
