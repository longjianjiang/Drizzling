//
//  ThreeDaysForecastView.swift
//  Drizzling
//
//  Created by longjianjiang on 2017/3/4.
//  Copyright © 2017年 Jiang. All rights reserved.
//

import UIKit
import Kingfisher

class ForecastCell: UICollectionViewCell {

    lazy var weekLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor.black
        label.textAlignment = .center
        return label
    }()
    
    lazy var temperatureLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor.black
        label.textAlignment = .center
        return label
    }()
    
    lazy var conditionImageview: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(weekLabel)
        contentView.addSubview(temperatureLabel)
        contentView.addSubview(conditionImageview)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        weekLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(contentView).offset(10)
            maker.left.right.equalTo(contentView)
            maker.height.equalTo(20)
        }
        
        temperatureLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(weekLabel.snp.bottom).offset(5)
            maker.left.right.equalTo(contentView)
            maker.height.equalTo(20)
        }
        
        conditionImageview.snp.makeConstraints { (maker) in
            maker.top.equalTo(temperatureLabel.snp.bottom).offset(5)
            maker.left.right.equalTo(contentView)
            maker.height.equalTo(40)
        }
    }
    
    
    func configCell(day: ForecastDay) {
        let unitStr = UserDefaults.standard.object(forKey: "unit") as! String
        weekLabel.text = day.forecastDate?["weekday_short"] as! String?
        if let icon = day.forecastIcon,
           let low = day.forecastLowTemperature?[unitStr],
           let high = day.forecastHighTemperature?[unitStr]{
                self.temperatureLabel.text = "\(high) / \(low)"
            let urlStr = "https://icons.wxug.com/i/c/k/\(icon).gif"
            conditionImageview.kf.setImage(with: URL(string: urlStr))
            }

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
class ThreeDaysForecastView: UIView {
    
    var collectionView: UICollectionView!
    var darkStyle = false
    
    var forecastDays: [ForecastDay]! = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let layout = UICollectionViewFlowLayout()
        
        layout.itemSize = CGSize(width: 100, height: 105)
        collectionView = UICollectionView.init(frame: self.bounds, collectionViewLayout: layout)
        collectionView.dataSource = self;
        collectionView.backgroundColor = UIColor.white
        collectionView.register(ForecastCell.self, forCellWithReuseIdentifier: "forecast")
        self.addSubview(collectionView)
       
        // add observer to response change theme notification
        NotificationCenter.default.addObserver(self, selector: #selector(changeToNight), name: NSNotification.Name(rawValue: "ChangeToNightNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(changeToDay), name: NSNotification.Name(rawValue: "ChangeToDayNotification"), object: nil)

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.snp.makeConstraints { (maker) in
            maker.left.bottom.right.top.equalTo(self)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc func changeToNight() {
        self.collectionView.backgroundColor = UIColor.black
        self.darkStyle = true
        self.collectionView.reloadData()
    }
    
    @objc func changeToDay() {
        self.collectionView.backgroundColor = UIColor.white
        self.darkStyle = false
        self.collectionView.reloadData()
    }
}

extension ThreeDaysForecastView : UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "forecast", for: indexPath) as! ForecastCell
        if forecastDays.count > 0 {
            if darkStyle {
                cell.weekLabel.textColor = UIColor.white
                cell.temperatureLabel.textColor = UIColor.white
            } else {
                cell.weekLabel.textColor = UIColor.black
                cell.temperatureLabel.textColor = UIColor.black
            }
             cell.configCell(day: (forecastDays?[indexPath.row+1])!)
        }
       
        return cell
    }
    
}
