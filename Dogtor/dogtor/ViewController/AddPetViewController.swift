//
//  AddPetViewController.swift
//  dogtor
//
//  Created by Jasper Oh on 2021/08/05.
//

import UIKit

class AddPetViewController: UIViewController {
    
    let pointColor : UIColor = UIColor.init(displayP3Red: 99/255, green: 197/255, blue: 148/255, alpha: 1)

    @IBOutlet weak var dangImage: UIImageView!
    var imageURL: URL?
    let picker = UIImagePickerController()
    
    @IBOutlet weak var dangName: UITextField!
    @IBOutlet weak var dangSpecies: UITextField!
    @IBOutlet weak var dangGender: UISegmentedControl!
    @IBOutlet weak var dangAge: UITextField!
    
    var petName: String?
    var petSpecies: String?
    var petGender: String?
    var petAge: String?
    
    let everyDangSpecies = ["골든 리트리버","말티즈","푸들","퍼그","레브라도","치와와","그 외"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dangName.layer.borderWidth = 1
        dangName.layer.cornerRadius = 8.0
        dangName.layer.borderColor = pointColor.cgColor
        dangSpecies.layer.borderWidth = 1
        dangSpecies.layer.cornerRadius = 8.0
        dangSpecies.layer.borderColor = pointColor.cgColor
        dangAge.layer.borderWidth = 1
        dangAge.layer.cornerRadius = 8.0
        dangAge.layer.borderColor = pointColor.cgColor
        
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        dangGender.backgroundColor = .white
        dangGender.selectedSegmentTintColor = pointColor
        dangGender.setTitleTextAttributes([.foregroundColor: UIColor.black], for: .normal)
        dangGender.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        
        dangImage.layer.cornerRadius = 40

        // Do any additional setup after loading the view.
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        dangImage.isUserInteractionEnabled = true
        dangImage.addGestureRecognizer(tapGestureRecognizer)
        
        createPickerView()
        dismissPickerView()
        
        
        dangGender.addTarget(self, action: #selector(segChanged(segCon:)), for: UIControl.Event.valueChanged)
        picker.delegate = self
        
        imageURL = URL(string: "http://localhost:8080/dogtor/image/dog-plus.png")
        let data = try? Data(contentsOf: imageURL!)
        dangImage.image = UIImage(data: data!)
       
    }
    
    func openGallery(){
          picker.sourceType = .photoLibrary
          present(picker, animated: false, completion: nil)
      }
      
    
    @objc func imageTapped(img: AnyObject) {
        openGallery()
        
    }

    func createPickerView(){
        let pickerView = UIPickerView()
        pickerView.delegate = self
        dangSpecies.inputView = pickerView
    }
    
    func dismissPickerView(){
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let button = UIBarButtonItem(title: "선택", style: .plain, target: self, action: #selector(self.dismissAction))
        toolBar.setItems([button], animated: true)
        toolBar.isUserInteractionEnabled = true
        dangSpecies.inputAccessoryView = toolBar
       }
    
    @objc func dismissAction(){
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    @objc func segChanged(segCon: UISegmentedControl){
        
        switch segCon.selectedSegmentIndex {
        case 0:
            petGender = "남"
        case 1:
            petGender = "여"
        case 2:
            petGender = "중성화"
        default:
            petGender = ""
        }
        
        
    }

    @IBAction func AddDangInfo(_ sender: UIBarButtonItem) {
        print("insert DangInfo")
                
        petName = dangName.text
        petSpecies = dangSpecies.text
        petAge = dangAge.text
        
        print(imageURL!, petName!, petAge! ,  petSpecies! , petGender!)
        
        let newPetInsertModel = NewPetInsertModel()
        //        \(Share.userEmail) 수정해줘야함!!!!!
        newPetInsertModel.uploadImageFile(at: imageURL!, petName: petName!, petAge: petAge!, petSpecies: petSpecies!, petGender: petGender!, userId: Share.userEmail, completionHandler: {_,_ in
                print("Upload Success")
        })
        let resultAlert = UIAlertController(title: "완료", message: "입력이 되었습니다", preferredStyle: .alert)
        let onAction = UIAlertAction(title: "OK", style: .default, handler: {ACTION in

            self.navigationController?.popViewController(animated: true)
        })

        resultAlert.addAction(onAction)
        present(resultAlert, animated: true, completion: nil)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
          self.view.endEditing(true)
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

extension AddPetViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            dangImage.image = image
            //업로드에 사용할 url
            imageURL = info[UIImagePickerController.InfoKey.imageURL] as? URL
            
            print(imageURL as Any)
        }
        dismiss(animated: true, completion: nil)
    }
    
}

extension AddPetViewController: UITextFieldDelegate ,UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return everyDangSpecies.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return everyDangSpecies[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        dangSpecies.text = everyDangSpecies[row]
    }
}


