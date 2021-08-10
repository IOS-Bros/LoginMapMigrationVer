//
//  LoginViewController.swift
//  dogtor
//
//  Created by 예쁘고 비싼 thㅡ레기 on 2021/08/02.
//

import UIKit
import GoogleSignIn
import KakaoSDKAuth
import KakaoSDKUser
import KakaoSDKTalk

let myURL = "127.0.0.1"


class LoginViewController: UIViewController {
    
    var API : String = ""
    var userEmail : String = ""
    var userImageURL : URL?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor.init(displayP3Red: 99/255, green: 197/255, blue: 148/255, alpha: 1)
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        print("LoginViewController - UserEmail : \(Share.userEmail)")
    }
    
    
    @IBAction func btnGoogle(_ sender: UIButton) {
        
        let signInConfig = GIDConfiguration.init(clientID: "619955076758-7f30hc5sr2ses6ioljsco1uqgat4hbv4.apps.googleusercontent.com")
        
        GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self) { user, error in
            guard error == nil else {
                return
            }
            
            self.API = "Google"
            self.userEmail = (user?.profile!.email)!
            self.userImageURL = (user?.profile?.imageURL(withDimension: 100))!
            self.checkLogin(self.userEmail)
            
            print("checkLog@objc in->btnGoogle : \(self.userEmail)")
          }
        
    }
    
    @IBAction func btnKaKao(_ sender: UIButton) {
        
        UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                if let error = error {
                    print("Error1: \(error.localizedDescription)")
                }
                else {
                    print("loginWithKakaoAccount() success.")
                    TalkApi.shared.profile {(profile, error) in
                        if let error = error {
                            print("프로필 : \(error.localizedDescription)")
                        } else {
                            print("profile() success.")
                            self.userImageURL = profile?.thumbnailUrl!
                            print("이미지 : \(self.userImageURL)")
                            //do something
                            _ = profile
                        }
                    }
                    UserApi.shared.me(completion: { (user, error) in
                        if let error = error {
                            print("Error2: \(error.localizedDescription)")
                            } else {
                                print("me() success.")
                                self.userEmail = (user?.kakaoAccount?.email!)!
                                print("로그인 : \(self.userEmail)")
                                self.API = "kakao"

                                self.checkLogin(self.userEmail)
                            }
                    })
                    
                }
            }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "firstLogin" {
            let loginInsertView = segue.destination as! LoginInsertViewController
            print("prepare : \(API), \(userEmail), \(userImageURL)")
            loginInsertView.receiveUserInfo(API, userEmail, userImageURL!)
        }else{
            let mainVC = self.storyboard?.instantiateViewController(withIdentifier: "main")
                mainVC?.modalPresentationStyle = .fullScreen
                self.present(mainVC!, animated: true, completion: nil)
                self.navigationController?.popViewController(animated: false)
        }
    }
    
    
    func checkLogin(_ email : String) {
        let checkLoginModel = CheckLoginModel()
        checkLoginModel.checkUser(userEmail)
        checkLoginModel.delegate = self
    }
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension UIViewController : CheckLoginModelProtocol {
    func checkLogin(items: NSMutableArray) {
        let userDB: UserDBModel = items[0] as! UserDBModel
        Share.userEmail = userDB.email!
        Share.userImage = userDB.image!
        Share.userNickName = userDB.nickName!
        
        UserDefaults.standard.set(Share.userEmail, forKey: "email")
        UserDefaults.standard.set(Share.userNickName, forKey: "nickname")
        UserDefaults.standard.set(Share.userImage, forKey: "image")
        
        print("CheckLoginModelProtocol : \(userDB.email)")
        if userDB.API == "0" {
            performSegue(withIdentifier: "firstLogin", sender: self)
            
        } else {
            let mainVC = self.storyboard?.instantiateViewController(withIdentifier: "main")
                mainVC?.modalPresentationStyle = .fullScreen
                self.present(mainVC!, animated: true, completion: nil)
                self.navigationController?.popViewController(animated: false)
        }
    }
}
