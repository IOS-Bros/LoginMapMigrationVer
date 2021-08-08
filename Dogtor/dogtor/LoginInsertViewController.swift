//
//  LoginInsertViewController.swift
//  dogtor
//
//  Created by 예쁘고 비싼 thㅡ레기 on 2021/08/02.
//

import UIKit

class LoginInsertViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tfNicName: UITextField!
    
    var receiveGoogle : String = ""
    var receiveUserEmail : String = ""
    var receiveUserImageURL : URL?
    
    var userNicName : String = ""
    
    var isDuplicateCheck : Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("LoginInsertViewController")
//        let url = URL(string: receiveUserImage)
        do {
            let data = try Data(contentsOf: receiveUserImageURL!)
            imageView.image = UIImage(data: data)
        } catch { }

        
        tfNicName.text = receiveUserEmail
        
        
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goMyPage" {
                   let vc = segue.destination as? MyPageViewController
                   if let index = sender as? Int{
                        vc?.myPageNickName.text = userNicName
                        vc?.receiveUserImageURL = self.receiveUserImageURL
                   }
            }
    }
    
    @IBAction func btnDuplicateCheck(_ sender: UIButton) {
        userNicName = tfNicName.text!
        checkNickNames()
    }
    
    @IBAction func btnFinish(_ sender: UIBarButtonItem) {
        print("btnFinish")
        userNicName = tfNicName.text!
        
        if isDuplicateCheck == true {
            let loginInsertModel = LoginInsertModel()
            let result = loginInsertModel.insertGoogle(receiveGoogle, receiveUserEmail, receiveUserImageURL!, userNicName)
            
            if result {
                let resultAlert = UIAlertController(title: "완료", message: "입력이 되었습니다", preferredStyle: .alert)
                let onAction = UIAlertAction(title: "OK", style: .default, handler: {ACTION in
                    let mainVC = self.storyboard?.instantiateViewController(withIdentifier: "main")
                        mainVC?.modalPresentationStyle = .fullScreen
                        self.present(mainVC!, animated: true, completion: nil)
                        self.navigationController?.popViewController(animated: false)
                })
                
                resultAlert.addAction(onAction)
                present(resultAlert, animated: true, completion: nil)
                
            } else {
                let resultAlert = UIAlertController(title: "완료", message: "에러가 발생 되었습니다", preferredStyle: .alert)
                let onAction = UIAlertAction(title: "OK", style: .default, handler: {ACTION in
                    self.navigationController?.popViewController(animated: true)
                })
                
                resultAlert.addAction(onAction)
                present(resultAlert, animated: true, completion: nil)
            }
        } else {
            let resultAlert = UIAlertController(title: "경고", message: "중복 확인을 해주세요.", preferredStyle: .alert)
            let onAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
            resultAlert.addAction(onAction)
            present(resultAlert, animated: true, completion: nil)
        }
        
    }
    
    func checkNickNames() {
        let checkNickNameModel = CheckNicNameModel()
        checkNickNameModel.checkUser(userNicName)
        checkNickNameModel.delegate = self
    }
    
    
    func receiveUserInfo(_ google : String, _ userEmail : String, _ userImageURL : URL) {
        self.receiveGoogle = google
        self.receiveUserEmail = userEmail
        self.receiveUserImageURL = userImageURL
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


extension LoginInsertViewController : CheckNicNameModelProtocol {
    func itemDownloaded(items: NSMutableArray) {
        let userDB: UserDBModel = items[0] as! UserDBModel
        
        
        print("CheckLoginModelProtocol : \(userDB.nickName)")
        if userDB.nickName == "0" {
            let resultAlert = UIAlertController(title: "중복확인", message: "사용 가능한 닉네임입니다.", preferredStyle: .alert)
            let onAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
            resultAlert.addAction(onAction)
            present(resultAlert, animated: true, completion: nil)
            isDuplicateCheck = true
        } else {
            let resultAlert = UIAlertController(title: "중복확인", message: "이미 사용중인 닉네입닙니다.", preferredStyle: .alert)
            let onAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
            resultAlert.addAction(onAction)
            present(resultAlert, animated: true, completion: nil)
        }
    }
}
