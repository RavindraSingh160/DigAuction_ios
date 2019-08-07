//
//  sideMenu.swift
//  PantherApp1
//
//  Created by Adarsh on 05/07/18.
//  Copyright © 2018 Adarsh. All rights reserved.
//
import UIKit

class Setting: NSObject{
    let name: String
    let imageName: String
    init(name: String, imageName: String){
        self.name = name
        self.imageName = imageName
    }
}

class SideMenu:NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    static let sharedInstance = SideMenu()
    let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
    let cellId = "cell"
    let cellId2 = "cell2"
    var show8 = false
    var viewcontroll: UIViewController!
    var settings = [Setting]()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        print("settings count: \(settings.count)")
        return settings.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//         print("name:cell ",settings[indexPath.row - 1].name)
        
        if indexPath.row == 0{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId2, for: indexPath) as! LogoCell
            cell.name.textColor = UIColor.white
            cell.cardNumber.textColor = UIColor.white
            cell.name.text = UserDefaults.standard.value(forKey: "username") as? String
//            cell.cardNumber.text = UserDefaults.standard.value(forKey: "password") as! String
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SettingCell
            let setting = settings[indexPath.row - 1]
//            print("name: ",settings[indexPath.row - 1].name)
            cell.setting = setting
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == 0 {
            return CGSize(width: collectionView.frame.width, height: 200)
        }
        return CGSize(width: collectionView.frame.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0 
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var indexpath = 0
//        let setting = settings[indexPath.row - 1]
//        print("setting name: ", setting.name)
        indexpath = indexPath.row - 1
        //---------------------------------------
        handleDismiss()
            if SideMenu.sharedInstance.show8{
                print("show 8")
                switch indexpath{
                case 0:
                    goToHome()
                case 1:
                    goToWeeklyOffer()
                case 2:
                    goToCard()
                case 3:
                    goToService()
                case 4:
                    goToContacts()
//                case 5:
//                    goToMemberDetails()
                case 5:
                    goToNotification()
                case 6:
                    logOutApi()
//                    logOut()
                default:
                    print("wrong case")
                }
            }else{
                print("show 5")
                switch indexpath{
                case 0:
                    goToHome()
                case 1:
                    goToWeeklyOffer()
                case 2:
                    goToService()
                case 3:
                    goToContacts()
                case 4:
                    goToLogin()
                default:
                    print("wrong case")
                }
//            }
        }
    }
    
    fileprivate func goToMemberDetails(){
//        let next = storyboard.instantiateViewController(withIdentifier: "MemberDetailsViewController") as! MemberDetailsViewController
//        viewcontroll.navigationController?.pushViewController(next, animated: true)
    }
    
    fileprivate func logOut(){
        let alertController = UIAlertController(title: "", message: "Are you sure you want to logout?", preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "Yes", style: .default) { (action:UIAlertAction!) in
            self.logOutApi()
        }
        let cancel = UIAlertAction(title: "No", style: .cancel)
        alertController.addAction(OKAction)
        alertController.addAction(cancel)
        viewcontroll.present(alertController, animated: true, completion:nil)
    }
    
    fileprivate func logOutApi(){
        
    }
    
    fileprivate func goToNotification(){
    }
    
    fileprivate func goToCard(){
    }
    
    fileprivate func goToWeeklyOffer(){
    }

    fileprivate func goToContacts(){
    }

    fileprivate func goToLogin(){
    }
    
    fileprivate func goToHome(){
//        for controller in viewcontroll.navigationController!.viewControllers as Array {
//            if controller.isKind(of: HomeViewController.self) {
//                _ =  viewcontroll.navigationController!.popToViewController(controller, animated: true)
//                return
//            }
//        }
    }
    
    fileprivate func goToService(){
    }
    
    let blackView = UIView()
    let collectionViewSide: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: UIScreen.main.bounds.height), collectionViewLayout: layout)
        cv.backgroundColor = UIColor.white
        return cv
    }()
    @objc func showSideBar(_ objVC : UIViewController!){
        //show menu
//        settings.removeAll()
//            print("5")
//        settings = [Setting(name: "Home", imageName: "Home.png"), Setting(name: "Weekly Special", imageName: "Weekly_Special.png"), Setting(name: "Services", imageName: "Services.png"), Setting(name: "Contact and Hours", imageName: "Contact_Hours.png"), Setting(name: "Login", imageName: "Logout.png")]
        
        self.viewcontroll = objVC
        if let window = UIApplication.shared.keyWindow{
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
            window.addSubview(blackView)
            window.addSubview(collectionViewSide)
            blackView.frame = window.frame
            blackView.alpha = 0
            UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseIn, animations: {
                self.blackView.alpha = 1
                self.collectionViewSide.frame = CGRect(x: 0, y: 0, width: window.frame.width * 0.85, height: window.frame.height)}, completion: nil)
        }
        self.collectionViewSide.reloadData()
    }
    @objc func handleDismiss(){
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseOut, animations: {self.blackView.alpha = 0
            self.collectionViewSide.frame = CGRect(x: 0, y: 0, width: 0, height: self.collectionViewSide.frame.height)}, completion: nil)
    }
    override init(){
        super.init()
//        print("init menu")
        collectionViewSide.dataSource = self
        collectionViewSide.delegate = self
        collectionViewSide.backgroundColor = UIColor.white//(white: 1, alpha: 0.83)
        collectionViewSide.register(SettingCell.self, forCellWithReuseIdentifier: cellId)
        collectionViewSide.register(LogoCell.self, forCellWithReuseIdentifier: cellId2)
    }
    deinit{
        print("deinit menu")
    }
}
