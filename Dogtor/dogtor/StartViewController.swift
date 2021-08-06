//
//  StartViewController.swift
//  dogtor
//
//  Created by 예쁘고 비싼 thㅡ레기 on 2021/08/06.
//

import UIKit

var DBEmail = ""

class StartViewController: UIViewController {
    
    // Share 생기면 수정
    var userEmail = "k_ye@naver.com"
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let time = DispatchTime.now() + .seconds(1)
        
        
        checkLogin(userEmail)
        
        DispatchQueue.main.asyncAfter(deadline: time, execute: self.moveToMain)
        
//        if let userEmail = UserDefaults.standard.string(forKey: "Email") {
//            performSegue(withIdentifier: "existingLogin", sender: self)
//        }
    } // viewDidLoad
    
    
    func moveToMain(){
        if DBEmail == "0" {
            print("go to Login")
            let mainVC = self.storyboard?.instantiateViewController(withIdentifier: "login")
                mainVC?.modalPresentationStyle = .fullScreen
                self.present(mainVC!, animated: true, completion: nil)
                self.navigationController?.popViewController(animated: false)
        //            performSegue(withIdentifier: "firstLogin", sender: self)
        } else if DBEmail == UserDefaults.standard.string(forKey: "Email") {
            print("go to Main")
            let mainVC = self.storyboard?.instantiateViewController(withIdentifier: "main")
                mainVC?.modalPresentationStyle = .fullScreen
                self.present(mainVC!, animated: true, completion: nil)
                self.navigationController?.popViewController(animated: false)
        }
//      let mainVC = self.storyboard?.instantiateViewController(withIdentifier: "login")
//        mainVC?.modalPresentationStyle = .fullScreen
//        self.present(mainVC!, animated: true, completion: nil)
//        self.navigationController?.popViewController(animated: false)
    } //moveToMain
    
    
    func checkLogin(_ email : String) {
        let checkUserModel = CheckUserModel()
        checkUserModel.checkUser(userEmail)
        checkUserModel.delegate = self
    } // checkLogin
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

} // StartViewController

extension UIViewController : CheckUserModelProtocol {
    func checkUser(items: NSMutableArray) {
        let userDB : UserDBModel = items[0] as! UserDBModel
        DBEmail = userDB.email!
        UserDefaults.standard.set(DBEmail, forKey: "Email")
        
        print("StartViewController : CheckLoginModelProtocol - \(String(describing: userDB.email))")
        print("자동로그인 : \(UserDefaults.standard.set(DBEmail, forKey: "Email"))")
        
        
        
//        if userDB.email == "0" {
//            let mainVC = self.storyboard?.instantiateViewController(withIdentifier: "login")
//              mainVC?.modalPresentationStyle = .fullScreen
//              self.present(mainVC!, animated: true, completion: nil)
//              self.navigationController?.popViewController(animated: false)
////            performSegue(withIdentifier: "firstLogin", sender: self)
//        } else {
//            let mainVC = self.storyboard?.instantiateViewController(withIdentifier: "main")
//              mainVC?.modalPresentationStyle = .fullScreen
//              self.present(mainVC!, animated: true, completion: nil)
//              self.navigationController?.popViewController(animated: false)
//        }
    }
}





