//
//  LJCityListViewController.swift
//  Drizzling
//
//  Created by longjianjiang on 2017/10/20.
//  Copyright © 2017年 Jiang. All rights reserved.
//

import UIKit

class LJCityListViewController: UIViewController {

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.text = "Drizzling"
        label.textColor = UIColor.black
        label.font = UIFont.init(name: "Courier", size: 30)
        return label
    }()
    
    lazy var searchBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setBackgroundImage(UIImage.init(named: "search_btn"), for: .normal)
        return btn
    }()
    
    var cityListView: UICollectionView!
    
    //MARK: life cycle
    func setupSubview() {
        view.addSubview(titleLabel)
        titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 65).isActive = true
        
        view.addSubview(searchBtn)
        searchBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25).isActive = true
        searchBtn.topAnchor.constraint(equalTo: view.topAnchor, constant: 68).isActive = true
        
        cityListView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
        cityListView.dataSource = self
        cityListView.delegate = self
        cityListView.translatesAutoresizingMaskIntoConstraints = false
        cityListView.backgroundColor = UIColor.white
        cityListView.register(LJCityCollectionViewCell.self, forCellWithReuseIdentifier: LJCityCollectionViewCellIdentifier)
        cityListView.register(LJAboutCollectionViewCell.self, forCellWithReuseIdentifier: LJAboutCollectionViewCellIdentifier)
        cityListView.collectionViewLayout = UICollectionViewFlowLayout()
        cityListView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        view.addSubview(cityListView)
        
        cityListView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        cityListView.topAnchor.constraint(equalTo: view.topAnchor, constant: 123).isActive = true
        cityListView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        cityListView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        setupSubview()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
extension LJCityListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cityCell = collectionView.dequeueReusableCell(withReuseIdentifier: LJCityCollectionViewCellIdentifier, for: indexPath) as? LJCityCollectionViewCell
        let aboutCell = collectionView.dequeueReusableCell(withReuseIdentifier: LJAboutCollectionViewCellIdentifier, for: indexPath) as? LJAboutCollectionViewCell
        
        if indexPath.row == 3 {
            return aboutCell!
        }
        return cityCell!
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    
}

extension LJCityListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: LJConstants.kScreenWidth - 40,
                      height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 30
    }
}

