//
//  MyPageViewController.swift
//  dogtor
//
//  Created by Jasper Oh on 2021/08/03.
//

import UIKit

class MyPageViewController: UIViewController, UIGestureRecognizerDelegate{
    
    @IBOutlet weak var dangView: UICollectionView!
    
    @IBOutlet weak var myPageImage: UIImageView!
    @IBOutlet weak var myPageNickName: UILabel!

    var receiveUserImageURL : URL?
    
    var myDogName = Array<String>()
    var myDogImage = Array<String>()
    var myDogId = Array<String>()
    var myDogSpecies = Array<String>()
    var myDogGender = Array<String>()
    var myDogAge = Array<String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("언제 실행되는거야!!!!5")
        
        // Do any additional setup after loading the view
        
//        getPetInfo("ohyj0906@gmail.com")
//        dangView.delegate = self
//        dangView.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getPetInfo("ohyj0906@gmail.com")
//        let checkPetInfo = CheckPetInfoModel()
//        checkPetInfo.checkPet("ohyj0906@gmail.com")
//        checkPetInfo.delegate = self
//        dangView.reloadData()
    }
    
    func getPetInfo(_ email: String){

        let checkPetInfo = CheckPetInfoModel()
        checkPetInfo.checkPet(email)
        checkPetInfo.delegate = self
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "dangModify"{
//            let cell = sender as! MyPageCollectionViewCell
//            let indexPath = self.dangView.indexPath(for: cell)
            let modifyView = segue.destination as! ModifyPetViewController
            modifyView.receiveInfo(myDogId[sender as! Int], myDogName[sender as! Int], myDogImage[sender as! Int], myDogSpecies[sender as! Int], myDogGender[sender as! Int], myDogAge[sender as! Int])
        }
    }


}

extension MyPageViewController : CheckPetInfoModelProtocol {
    func petInfoDownloaded(items: NSMutableArray) {
        print("여기서 몇개지",items.count)
        myDogName.removeAll()
        myDogImage.removeAll()
        myDogId.removeAll()
        myDogSpecies.removeAll()
        myDogGender.removeAll()
        myDogAge.removeAll()
        
        for i in 0..<items.count{
            let petDB: PetDBModel = items[i] as! PetDBModel
            myDogName.append(petDB.PetName!)
            myDogImage.append(petDB.PetImage!)
            myDogId.append(petDB.PetId!)
            myDogSpecies.append(petDB.PetSpecies!)
            myDogGender.append(petDB.PetGender!)
            myDogAge.append(petDB.PetAge!)
            
        }
        
        print(myDogName.count)

        DispatchQueue.main.async {
           self.dangView.reloadData()
        }
    }
    
}


extension MyPageViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        
        return CGSize(width: collectionView.frame.width/3, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return myDogName.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row == myDogName.count{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dogAddCell", for: indexPath) as? UICollectionViewCell else {
                
                return UICollectionViewCell()
            }
            
            cell.backgroundColor = UIColor.lightGray
            cell.layer.borderWidth = 1.0
            cell.layer.borderColor = UIColor.darkGray.cgColor
            cell.layer.cornerRadius = 4
            
            return cell
        }else{
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? MyPageCollectionViewCell else {
               
                return UICollectionViewCell()
                
            }
            
//            let title = UILabel(frame: CGRect(x: 0, y: cell.bounds.size.height - 50 , width: cell.bounds.size.width, height: 50))
//            title.text = myDogName[indexPath.row]
//            title.textAlignment = .center
//            cell.contentView.addSubview(title)
            cell.lblDangName.text = myDogName[indexPath.row]
            let url = URL(string: "http://\(myURL):8080/dogtor/image/\(myDogImage[indexPath.row])")
            let data = try? Data(contentsOf: url!)
            cell.ivDangImage.image = UIImage(data: data!)
            cell.backgroundColor = UIColor.white
            
            cell.layer.borderWidth = 1.0
            cell.layer.borderColor = UIColor.darkGray.cgColor
            cell.layer.cornerRadius = 4
            
            // LongPressGesture cell
            let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
            lpgr.minimumPressDuration = 0.3
            lpgr.delaysTouchesBegan = true
            cell.contentView.addGestureRecognizer(lpgr)
            cell.addGestureRecognizer(lpgr)
           
//            cell.backgroundView = UIImageView(image: data)
            
            return cell
        }
        
    }

    @objc func handleLongPress(gestureReconizer: UILongPressGestureRecognizer) {
        guard gestureReconizer.state != .began else { return }
        let point = gestureReconizer.location(in: self.dangView)
        let indexPath = self.dangView.indexPathForItem(at: point)
        if let index = indexPath{
            print(index.row)
            let testAlert = UIAlertController(title: "My Dog", message: "\(myDogName[index.row])", preferredStyle: .actionSheet)
            
            // AlertAction
            let actionDefault = UIAlertAction(title: "댕댕이 바꾸기", style: .default, handler: {ACTION in
//                self.dangView.register(UICollectionViewCell.self,forCellWithReuseIdentifier:"cell")
//                self.dangView.register(MyPageViewController.self, forCellWithReuseIdentifier: "cell")
                self.performSegue(withIdentifier: "dangModify", sender: index.row)
//                self.performSegue(withIdentifier: "dangModify", sender: self)
            })
            let actionDestructive = UIAlertAction(title: "댕댕이 지우기", style: .destructive, handler: {ACTION in
                // Controller 초기화
                let testAlert = UIAlertController(title: "My Dog", message: "정말.. 지우실건가요?", preferredStyle: .alert)

                // AlertAction
                let actionDefault = UIAlertAction(title: "네..ㅜㅜ", style: .default, handler: {ACTION in
                    let deleteModel = PetDeleteModel()
                    let result = deleteModel.deletePet(petId: self.myDogId[index.row])
                    
                    if result{
                        let resultAlert = UIAlertController(title: "완료", message: "댕댕아 잘가!", preferredStyle: .alert)
                        let onAction = UIAlertAction(title: "OK", style: .default, handler: {ACTION in
                            self.viewWillAppear(true)
                        })
                        resultAlert.addAction(onAction)
                        self.present(resultAlert, animated: true, completion: nil)
                    }else{
                        let resultAlert = UIAlertController(title: "실패", message: "에러가 발생 되었습니다!", preferredStyle: .alert)
                        let onAction = UIAlertAction(title: "OK", style: .default, handler: {ACTION in
                            self.navigationController?.popViewController(animated: true)
                        })
                        resultAlert.addAction(onAction)
                        self.present(resultAlert, animated: true, completion: nil)
                    }
                })
                let actionCancel = UIAlertAction(title: "아니욥!!", style: .cancel, handler: nil)
                
                // Controller와 Action결합
                testAlert.addAction(actionDefault)
                testAlert.addAction(actionCancel)
                
                // 화면 띄우기
                self.present(testAlert, animated: true, completion: nil)
            })
            let actionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            // Controller와 Action결합
            testAlert.addAction(actionDefault)
            testAlert.addAction(actionDestructive)
            testAlert.addAction(actionCancel)
            
            // 화면 띄우기
            present(testAlert, animated: true, completion: nil)
        }
        else{
            print("Could not find index path")
        }
    }
}
