//
//  LJAboutCollectionViewCell.swift
//  Drizzling
//
//  Created by longjianjiang on 2017/10/21.
//  Copyright © 2017年 Jiang. All rights reserved.
//

import UIKit

let LJAboutCollectionViewCellIdentifier = "LJAboutCollectionViewCellIdentifier"

class LJAboutCollectionViewCell: UICollectionViewCell {
    var contactLabel = UILabel()
    var apiLabel = UILabel()
    var msgLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.layer.contents = UIImage.init(named: "about_bg")?.cgImage
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 1.0
        self.layer.borderColor = LJConstants.themeColor.cgColor
        self.layer.masksToBounds = true
        setupSubview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addSomeConstraints()
    }
    
    func setupSubview() {
        contactLabel.translatesAutoresizingMaskIntoConstraints = false
        contactLabel.textAlignment = .center
        contactLabel.textColor = UIColor.black
        contactLabel.font = UIFont.systemFont(ofSize: 15)
        contactLabel.text = "If you have any question about this app,please contact us at brucejiang5.7@gmail.com"
        contactLabel.numberOfLines = 0
        contentView.addSubview(contactLabel)
        
        apiLabel.translatesAutoresizingMaskIntoConstraints = false
        apiLabel.textAlignment = .center
        apiLabel.textColor = UIColor.black
        apiLabel.font = UIFont.systemFont(ofSize: 10)
        apiLabel.text = "Weather API From The Weather Company, LLC"
        contentView.addSubview(apiLabel)
        
        msgLabel.translatesAutoresizingMaskIntoConstraints = false
        msgLabel.textAlignment = .center
        msgLabel.textColor = UIColor.black
        msgLabel.font = UIFont.systemFont(ofSize: 10)
        msgLabel.text = "Designed by longjianjiang in China"
        contentView.addSubview(msgLabel)
    }
    
    func addSomeConstraints() {
        contactLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        contactLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        contactLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -60).isActive = true
        
        apiLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        apiLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        apiLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30).isActive = true
        
        msgLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        msgLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        msgLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
    }
}
