//
//  ViewController.swift
//  DigAuction
//
//  Created by Adarsh on 05/08/19.
//  Copyright © 2019 Anushka. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var viewUsername: UIView!
    @IBOutlet weak var viewPassword: UIView!
    @IBOutlet weak var imgRememberMe: UIImageView!
    @IBOutlet weak var btnSignIn: UIButton!
    @IBOutlet weak var btnRememberMe: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpLayout()
    }

    fileprivate func setUpLayout(){
        
        btnSignIn.setRoundedGreenBackground()
        viewUsername.setRoundedTransparentBackground()
        viewPassword.setRoundedTransparentBackground()
        txtUsername.backgroundColor = UIColor.clear
        txtPassword.backgroundColor = UIColor.clear
        txtUsername.attributedPlaceholder = NSAttributedString(string: "Username",
                                                               attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        txtPassword.attributedPlaceholder = NSAttributedString(string: "Password",
                                                               attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        imgRememberMe.image = UIImage(named: "unchecked.png")

    }

    
    @IBAction func rememberMeAction(_ sender: UIButton) {
        if sender.tag == 0{
            sender.tag = 1
            imgRememberMe.image = UIImage(named: "checked.png")
        }else{
            sender.tag = 0
            imgRememberMe.image = UIImage(named: "unchecked.png")
        }
    }
    
    class aa: Decodable, Encodable{
        var username = ""
        var password = ""
    }
    @IBAction func loginAction(_ sender: Any) {
        if txtUsername.text == "" || txtPassword.text == ""{
            showAlertView(title: "Alert", message: "Cannot leave username or password empty")
        }else{
            let username = txtUsername.text!
            let password = txtPassword.text!
            LoaderController.sharedInstance.showLoader()
            let url = URL(string: "https://www.digauction.com/api/login")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            let dict = NSMutableDictionary()
            dict.setValue("\(username)", forKey: "username")//adarsh
            dict.setValue("\(password)", forKey: "password")//Comicwow2018!
            print("Dict:",dict)
            //create the session object
            let session = URLSession.shared
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: dict) // pass dictionary to nsdata object and set it as request body
            } catch let error {
                print(error.localizedDescription)
            }
            
            //create dataTask using the session object to send data to the server
            let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
                
                LoaderController.sharedInstance.removeLoader()
                
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                    print("statusCode should be 200, but is: \(httpStatus.statusCode)\n response \(String(describing: response))")
                    return
                }
                guard error == nil else {
                    return
                }
                
                guard let data = data else {
                    return
                }
                if let authToken = String(data: data, encoding: String.Encoding.utf8){
                    print("login succesfull:\(authToken)")
                    if authToken.contains("<"){
                        DispatchQueue.main.async {
                            self.showAlertView(title: "Alert", message: "Invalid username or password")
                        }
                    }else{
                        DispatchQueue.main.async {
                        UserDefaults.standard.set(authToken, forKey: "AuthToken")
                        UserDefaults.standard.set(username, forKey: "username")
                        UserDefaults.standard.set(password, forKey: "password")
//                        self.getApi(url_string: "Category/Children/9", CompletionHandler: {data , error in
//                                if data != nil{
//                                    let json = try! JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! NSArray
//                                    print("categories array:",json)
//                                    let nc = self.storyboard?.instantiateViewController(withIdentifier: "NavigationVC") as! NavigationVC
//                                    self.present(nc, animated: true, completion: nil)
//                                }else{
//                                    self.showAlertView(title: "", message: error ?? "Error")
//                                }
//                            }
//                        )
                            
                            self.fetchGenericData(urlString: "Category/Children/9", parameters: "", method: "GET", completion: {(objCommonResponse: [Categories]) in
                                DispatchQueue.main.async {
                                    print(objCommonResponse)
                                    HomeVC.categories = objCommonResponse
                                    let nc = self.storyboard?.instantiateViewController(withIdentifier: "NavigationVC") as! NavigationVC
                                    self.present(nc, animated: true, completion: nil)
                                }
                            })
                        }
                    }
                }else{
                    DispatchQueue.main.async {
                        self.showAlertView(title: "Alert", message: "Invalid username or password")
                    }
                }
                //            print("response ------ ",String(data: data, encoding: String.Encoding.utf8))
            })
            task.resume()
        }
    }
    
    fileprivate func goToHome(){
        let vc = storyboard?.instantiateViewController(withIdentifier: "NavigationVC") as! NavigationVC
        self.present(vc, animated: true, completion: nil)
    }
    
}
