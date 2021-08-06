//
//  MyPageViewController.swift
//  dogtor
//
//  Created by Jasper Oh on 2021/08/03.
//

import UIKit




class MyPageViewController: UIViewController{
    
    @IBOutlet weak var dangView: UICollectionView!
    
    @IBOutlet weak var myPageImage: UIImageView!
    @IBOutlet weak var myPageNickName: UILabel!
    

    var receiveUserImageURL : URL?
        
    
    var myDogName = Array<String>()
    var myDogImage = Array<String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("언제 실행되는거야!!!!5")
        
        // Do any additional setup after loading the view
        
        getPetInfo("ohyj0906@gmail.com")
        
            
    }
    
    


    func getPetInfo(_ email: String){

        let checkPetInfo = CheckPetInfoModel()
        checkPetInfo.checkPet(email)
        checkPetInfo.delegate = self
    }


}

extension MyPageViewController : CheckPetInfoModelProtocol {
    func petInfoDownloaded(items: NSMutableArray) {
        
        for i in 0..<items.count{
            let petDB: PetDBModel = items[i] as! PetDBModel
            myDogName.append(petDB.PetName!)
            myDogImage.append(petDB.PetImage!)
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
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? UICollectionViewCell else {
                
                return UICollectionViewCell()
                
            }
            
            let title = UILabel(frame: CGRect(x: 0, y: cell.bounds.size.height - 50 , width: cell.bounds.size.width, height: 50))
            title.text = myDogName[indexPath.row]
            title.textAlignment = .center
            cell.contentView.addSubview(title)
            cell.backgroundColor = UIColor.white
            
            cell.layer.borderWidth = 1.0
            cell.layer.borderColor = UIColor.darkGray.cgColor
            cell.layer.cornerRadius = 4
            
            
            
       

            
            
//            cell.backgroundView = UIImageView(image: data)
            
            

            
            return cell
        }
        
    }
}






