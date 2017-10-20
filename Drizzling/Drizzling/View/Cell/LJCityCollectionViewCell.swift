//
//  LJCityCollectionViewCell.swift
//  Drizzling
//
//  Created by longjianjiang on 2017/10/20.
//  Copyright © 2017年 Jiang. All rights reserved.
//

import UIKit

let LJCityCollectionViewCellIdentifier = "LJCityCollectionViewCellIdentifier"

class LJCityCollectionViewCell: UICollectionViewCell {
    
    var dateLabel = UILabel()
    var temperatureLabel = UILabel()
    var conditionImage = UIImageView()
    var cityLabel = UILabel()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 1.0
        self.layer.borderColor = LJConstants.themeColor.cgColor
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowOpacity = 0.7
        self.layer.shadowRadius = 3.0
        setupSubview()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addSomeConstraints()
    }
    func setupSubview() {
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.textAlignment = .left
        dateLabel.font = UIFont.systemFont(ofSize: 13)
        dateLabel.text = "Sunday, Oct 17"
        dateLabel.textColor = UIColor.black
        contentView.addSubview(dateLabel)
        
        temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        temperatureLabel.textAlignment = .left
        temperatureLabel.font = UIFont.systemFont(ofSize: 70)
        temperatureLabel.text = "27º"
        temperatureLabel.textColor = UIColor.black
        contentView.addSubview(temperatureLabel)
        
        conditionImage.translatesAutoresizingMaskIntoConstraints = false
        conditionImage.image = UIImage(named: "sunny")
        contentView.addSubview(conditionImage)
        
        cityLabel.translatesAutoresizingMaskIntoConstraints = false
        cityLabel.textAlignment = .center
        cityLabel.font = UIFont.systemFont(ofSize: 30)
        cityLabel.textColor = UIColor.black
        cityLabel.text = "Nanjing"
        contentView.addSubview(cityLabel)
    }
    
    func addSomeConstraints() {
        dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30).isActive = true
        dateLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 28).isActive = true
        
        temperatureLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30).isActive = true
        temperatureLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 12).isActive = true
        
        cityLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        cityLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        cityLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
        
        conditionImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -35).isActive = true
        conditionImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
