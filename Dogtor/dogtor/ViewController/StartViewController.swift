//
//  StartViewController.swift
//  dogtor
//
//  Created by 예쁘고 비싼 thㅡ레기 on 2021/08/06.
//

import UIKit

class StartViewController: UIViewController {
    
    @IBOutlet weak var imageLogo: UIImageView!
    // Share 생기면 수정
//    var userEmail = "k_ye@naver.com"
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.init(displayP3Red: 99/255, green: 197/255, blue: 148/255, alpha: 1)
        print("StartViewController - UserEmail : \(Share.userEmail)")
        
        // MARK: - userCheck
        checkLogin(Share.userEmail)
        
        // MARK: - Splash View
        let time = DispatchTime.now() + .seconds(1)
        imageLogo.alpha = 0
        
        UIView.animate(withDuration: 1, delay: 0, options: .curveEaseOut, animations: {
            self.imageLogo.alpha = 1.0
        })
        DispatchQueue.main.asyncAfter(deadline: time, execute: self.moveToMain)
        
        
    } // viewDidLoad
    
    // MARK: -
    func moveToMain(){
        if Share.userEmail == "0" {
            print("go to Login")
            let mainVC = self.storyboard?.instantiateViewController(withIdentifier: "login")
                mainVC?.modalPresentationStyle = .fullScreen
                self.present(mainVC!, animated: true, completion: nil)
                self.navigationController?.popViewController(animated: false)
        }
        
        if let userDB = UserDefaults.standard.string(forKey: "email") {
            let mainVC = self.storyboard?.instantiateViewController(withIdentifier: "main")
                mainVC?.modalPresentationStyle = .fullScreen
                self.present(mainVC!, animated: true, completion: nil)
                self.navigationController?.popViewController(animated: false)
        }
    } //moveToMain
    
    // MARK: - checkUserModel
    func checkLogin(_ email : String) {
        let checkUserModel = CheckUserModel()
        checkUserModel.checkUser(Share.userEmail)
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
//        Share.userEmail = userDB.email!
//        Share.userImage = userDB.image!
//        Share.userNickName = userDB.nickName!
//
//        UserDefaults.standard.set(Share.userEmail, forKey: "email")
//        UserDefaults.standard.set(Share.userNickName, forKey: "nickname")
//        UserDefaults.standard.set(Share.userImage, forKey: "image")
        
        print("StartViewController : CheckLoginModelProtocol - \(String(describing: Share.userEmail))")
        print("자동로그인 : \(UserDefaults.standard.set(Share.userEmail, forKey: "Email"))")
        
    }
}





