//
//  SettingCell.swift
//  PantherApp1
//
//  Created by Adarsh on 06/07/18.
//  Copyright © 2018 Adarsh. All rights reserved.
//

import UIKit
class SettingCell: UICollectionViewCell{
    
//    override var isHighlighted: Bool{
//        didSet{
//            backgroundColor = isHighlighted ? UIColor.gray : UIColor.white
//            sideLabel.textColor = isHighlighted ? UIColor.white : UIColor.black
//            iconImageView.tintColor = isHighlighted ? UIColor.white : UIColor.darkGray
//        }
//    }
//
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    var setting: Setting?{
        didSet{
            sideLabel.text = setting?.name
            
            let imagename = setting?.imageName
            iconImageView.image = UIImage(named: imagename!)?.withRenderingMode(.alwaysTemplate)
            iconImageView.tintColor = UIColor.init(red: 241/255, green: 92/255, blue: 48/255, alpha: 1.0)//UIColor.darkGray
        }
    }
    
    let sideLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)//systemFont(ofSize: 15)
        return label
    }()
    
    let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    func setUpView(){
        addSubview(sideLabel)
        addSubview(iconImageView)
        addConstraintsWithFormat("H:|-20-[v0(30)]-40-[v1]|", views: iconImageView, sideLabel)
        addConstraintsWithFormat("V:|[v0]|", views: sideLabel)
        addConstraintsWithFormat("V:[v0(30)]", views: iconImageView)
        addConstraint(NSLayoutConstraint(item: iconImageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UIView {
    func addConstraintsWithFormat(_ format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
        }
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDictionary))
    }
}
