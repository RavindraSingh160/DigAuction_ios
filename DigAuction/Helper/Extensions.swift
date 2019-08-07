//
//  Utilities.swift
//  DigAuction
//
//  Created by Adarsh on 05/08/19.
//  Copyright © 2019 Anushka. All rights reserved.
//

import Foundation
import UIKit

extension UIButton{
    func setRoundedGreenBackground(){
        layer.cornerRadius = 10
        backgroundColor = UIColor(displayP3Red: 0, green: 133/255, blue: 119/255, alpha: 1)
    }
}

extension UIView{
    func setRoundedTransparentBackground(){
        backgroundColor = UIColor.white.withAlphaComponent(0)
        layer.borderColor = UIColor.gray.cgColor
        layer.borderWidth = 2
        layer.cornerRadius = 10
    }
}

extension UIViewController{
    
    func setUpMenuButton(){
        let menuBtn = UIButton(type: .custom)
        menuBtn.frame = CGRect(x: 0.0, y: 0.0, width: 25, height: 15)
        menuBtn.setImage(UIImage(named:"menu.png"), for: .normal)
        menuBtn.addTarget(self, action: #selector(handleMenu), for: UIControl.Event.touchUpInside)
        let leftmenuBarItem = UIBarButtonItem(customView: menuBtn)
        leftmenuBarItem.customView?.widthAnchor.constraint(equalToConstant: 25).isActive = true
        leftmenuBarItem.customView?.heightAnchor.constraint(equalToConstant: 15).isActive = true
        self.navigationItem.leftBarButtonItem = leftmenuBarItem
    }
    
    
    @objc func handleMenu(){
        SideMenu.sharedInstance.settings.removeAll()
        for i in 0..<HomeVC.categories.count{
            SideMenu.sharedInstance.settings.append(Setting(name: HomeVC.categories[i].Name, imageName: "Home.png"))
        }
        SideMenu.sharedInstance.showSideBar(self)
    }
    
    
    
    public func fetchGenericData<T: Decodable>(urlString: String, parameters: String, method: String,completion: @escaping (T) -> ()){
        LoaderController.sharedInstance.showLoader()
        let baseUrl = "https://www.digauction.com/api/"
        let url = URL(string: baseUrl+urlString)
        var request = URLRequest(url: url!)
        print("\n\nurl: \(String(describing: url))\n\n")
        request.httpMethod = method//"GET"
        request.addValue("RWX_BASIC \(UserDefaults.standard.value(forKey: "username") as! String):\(UserDefaults.standard.value(forKey: "password") as! String)", forHTTPHeaderField: "Authorization")
        if parameters != "" {
            print("parameters not empty: \(parameters)")
            request.httpBody = parameters.data(using: .utf8)
        }
        print("\nrequest :",request)
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("error: \(error?.localizedDescription ?? ""))")
                if let x = error as NSError?{
                    if x.code == -1009{
                        print("Not connected to internet")
                        if let topController = UIApplication.shared.keyWindow?.rootViewController {
                            while let presentedViewController = topController.presentedViewController {
                                presentedViewController.showAlertView(title: "Alert", message: "Please check network connection.")
                            }
                        }
                    }
                }
                LoaderController.sharedInstance.removeLoader()
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("statusCode should be 200, but is: \(httpStatus.statusCode)\n response \(String(describing: response))")
                return
            }
            do {
                let json = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as! NSArray
                print("json: \(json)")
                let obj = try JSONDecoder().decode(T.self, from: data)
                print("completed with success")
                //   print("json obj :",obj)
                completion(obj)
            }catch let jsonErr{
                print("failed to convert json: \(jsonErr.localizedDescription) , \n jsonErr : ",jsonErr)
            }
            LoaderController.sharedInstance.removeLoader()
            }.resume()
    }
    
    
    func showAlertView(title:String,message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (_) in
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    //-------------------------------------------------
    
    
//
//    public func loginWebService(username: String!, password: String, CompletionHandler: @escaping (NSDictionary?, String?) -> Void){
//    }
//
    
    public func getApi(url_string: String, CompletionHandler: @escaping (Data?, String?) -> Void){
        LoaderController.sharedInstance.showLoader()
        let baseUrl = "https://www.digauction.com/api/"+url_string
        let url = URL(string: baseUrl)!
        var request = URLRequest(url: url)
        print("url -",request)
        request.httpMethod = "GET"
        request.addValue("RWX_BASIC \(UserDefaults.standard.value(forKey: "username") as! String):\(UserDefaults.standard.value(forKey: "password") as! String)", forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("==========")
                LoaderController.sharedInstance.removeLoader()
                if let x = error as NSError?{
                    if x.code == -1009 || x.code == -1005 || x.code == -1003{
                        print("Not connected to internet")
                        DispatchQueue.main.async {
                            if var topController = UIApplication.shared.keyWindow?.rootViewController {
                                while let presentedViewController = topController.presentedViewController {
                                    topController = presentedViewController
                                }
                            }
                        }
                    }
                }
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response!)")
                print(response.debugDescription)
                return
            }
            DispatchQueue.main.async {
                CompletionHandler(data, "")
            }
            LoaderController.sharedInstance.removeLoader()
        }
        task.resume()
    }
    
    public func postWithoutImage(url_string: String, parameters : String, CompletionHandler: @escaping (NSDictionary?, String?) -> Void){
        LoaderController.sharedInstance.showLoader()
        print("parameters -",parameters)
        let baseUrl = "http://dashboard.doit.aw:8081/doit_copy/user2/"
        let url = URL(string: baseUrl+url_string)!
        var request = URLRequest(url: url)
        print("url -",request)
        request.httpMethod = "POST"
        print(UserDefaults.standard.value(forKey: "headerToken") as? String ?? "header not found!!")
        request.addValue(UserDefaults.standard.value(forKey: "headerToken") as? String ?? "", forHTTPHeaderField: "Doittoken")
        if parameters != "" {
            print("parameters not empty")
            request.httpBody = parameters.data(using: .utf8)
        }
        request.addValue("bollywoodtadka@123", forHTTPHeaderField: "Authtoken")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("==========")
                LoaderController.sharedInstance.removeLoader()
                if let x = error as NSError?{
                    if x.code == -1009 || x.code == -1005 || x.code == -1003{
                        print("Not connected to internet")
                        DispatchQueue.main.async {
                            if var topController = UIApplication.shared.keyWindow?.rootViewController {
                                while let presentedViewController = topController.presentedViewController {
                                    topController = presentedViewController
                                }
                            }
                        }
                    }
                }
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response!)")
                print(response.debugDescription)
                return
            }
            DispatchQueue.main.async {
                let json = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as! NSDictionary
                print("json : ",json)
                let statusmessage1 = String(describing: json["status"])
                let msg = json.value(forKey: "msg") as! String
                if (statusmessage1.contains("1")){
                    print("success")
                    CompletionHandler(json, msg)
                } else {
                    CompletionHandler(nil, msg)
                }
            }
            LoaderController.sharedInstance.removeLoader()
        }
        task.resume()
    }
}

extension Dictionary {
    func percentEscaped() -> String {
        return map { (key, value) in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            return escapedKey + "=" + escapedValue
            }
            .joined(separator: "&")
    }
}

extension CharacterSet {
    static let urlQueryValueAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="
        
        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        return allowed
    }()
}
