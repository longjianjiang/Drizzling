//
//  IntroduceView.swift
//  Drizzling
//
//  Created by longjianjiang on 2017/3/11.
//  Copyright © 2017年 Jiang. All rights reserved.
//

import UIKit


class IntroduceView: UIView {
    
    lazy var shareLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.text = "Press to share something with your friends"
        return label
    }()
    
    lazy var pullLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.text = "Pull down to get 3 day forecast"
        return label
    }()
    
    lazy var msgLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.text = "Hope to enjoy 😝"
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.gray
        self.addSubview(shareLabel)
        self.addSubview(pullLabel)
        self.addSubview(msgLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        pullLabel.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self)
            maker.center.equalTo(self)
            maker.height.equalTo(44)
        }
        
        shareLabel.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self)
            maker.bottom.equalTo(pullLabel.snp.top).offset(-100)
            maker.height.equalTo(44)
        }
        
        msgLabel.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self)
            maker.top.equalTo(pullLabel.snp.bottom).offset(100)
            maker.height.equalTo(44)
        }
    }

    func remove() {
       
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        UIView.beginAnimations("FlipAni", context: nil)
        UIView.setAnimationDuration(2)
        UIView.setAnimationCurve(.easeInOut)
        UIView.setAnimationTransition(.flipFromLeft, for: self, cache: true)
        UIView.commitAnimations()

        UIView.animate(withDuration: 0.5, delay: 1, options: .curveEaseInOut, animations: {
            self.alpha = 0
        }) { (_) in
            self.removeFromSuperview()
        }
        
    }

}
