//
//  LogoCell.swift
//  PantherApp1
//
//  Created by Adarsh on 06/07/18.
//  Copyright © 2018 Adarsh. All rights reserved.
//

import UIKit
class LogoCell: UICollectionViewCell{
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    let logo: UIImageView = {
        let menulogo = UIImageView()
        menulogo.frame = CGRect(x: 10, y: 40, width: UIScreen.main.bounds.width*0.3, height: 30)
        menulogo.image = UIImage(named: "logo.png")
        menulogo.contentMode = .scaleToFill
        return menulogo
    }()
    let backview: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(patternImage: UIImage(named: "bg.png")!)
        view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width*0.85, height: 180)
        return view
    }()
    
    let name: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    let number: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    let cardNumber: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setUpView(){
        addSubview(backview)
        addSubview(logo)
        addSubview(name)
        addSubview(cardNumber)

        addConstraintsWithFormat("V:|-30-[v0(70)]-5-[v1]-5-[v2]", views: logo, name, cardNumber)
        addConstraintsWithFormat("H:|[v0(200)]", views: logo)
        addConstraintsWithFormat("H:|-10-[v0]|", views: name)
        addConstraintsWithFormat("H:|-10-[v0]|", views: cardNumber)
    }
}
