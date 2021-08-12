//
//  ModifyPetViewController.swift
//  dogtor
//
//  Created by SeungYeon on 2021/08/06.
//

import UIKit

class ModifyPetViewController: UIViewController {
    
    let imgPicker = UIImagePickerController()
    var imageURL: URL?
    
    @IBOutlet weak var ivMyDog: UIImageView!
    @IBOutlet weak var tfMyDogName: UITextField!
    @IBOutlet weak var tfMyDogSpec: UITextField!
    @IBOutlet weak var scMyDogGender: UISegmentedControl!
    @IBOutlet weak var tfMyDogAge: UITextField!
    
    let everyDangSpecies = ["골든 리트리버","말티즈","푸들","퍼그","레브라도","치와와","그 외"]
    
    var receivemyDogId = ""
    var receivemyDogName = ""
    var receivemyDogImage = ""
    var receivemyDogSpecies = ""
    var receivemyDogGender = ""
    var receivemyDogAge = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tfMyDogName.text = receivemyDogName
        tfMyDogSpec.text = receivemyDogSpecies
        tfMyDogAge.text = receivemyDogAge
        
        createPickerView()
        dismissPickerView()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        ivMyDog.isUserInteractionEnabled = true
        ivMyDog.addGestureRecognizer(tapGestureRecognizer)
        
        imgPicker.delegate = self
        
        scMyDogGender.addTarget(self, action: #selector(segChanged(segCon:)), for: UIControl.Event.valueChanged)
        
        switch receivemyDogGender {
        case "남":
            scMyDogGender.selectedSegmentIndex = 0
        case "여":
            scMyDogGender.selectedSegmentIndex = 1
        case "중성화":
            scMyDogGender.selectedSegmentIndex = 2
        default:
            scMyDogGender.selectedSegmentIndex = 0
        }
        
        imageURL = URL(string: "http://\(myURL):8080/dogtor/image/\(receivemyDogImage)")
        let data = try? Data(contentsOf: imageURL!)
        ivMyDog.image = UIImage(data: data!)
    }
    
    func openGallery(){
        imgPicker.sourceType = .photoLibrary
        present(imgPicker, animated: false, completion: nil)
      }
      
    
    @objc func imageTapped(img: AnyObject) {
        
        openGallery()
        
    }
    
    func createPickerView(){
        let pickerView = UIPickerView()
        pickerView.delegate = self
        tfMyDogSpec.inputView = pickerView
    }
    
    func dismissPickerView(){
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let button = UIBarButtonItem(title: "선택", style: .plain, target: self, action: #selector(self.dismissAction))
        toolBar.setItems([button], animated: true)
        toolBar.isUserInteractionEnabled = true
        tfMyDogSpec.inputAccessoryView = toolBar
    }
    
    @objc func dismissAction(){
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    func receiveInfo(_ myDogId: String, _ myDogName: String, _ myDogImage: String, _ myDogSpecies: String, _ myDogGender: String, _ myDogAge: String) {
        receivemyDogId = myDogId
        receivemyDogName = myDogName
        receivemyDogImage = myDogImage
        receivemyDogSpecies = myDogSpecies
        receivemyDogGender = myDogGender
        receivemyDogAge = myDogAge
    }
    
    @objc func segChanged(segCon: UISegmentedControl){
        
        switch segCon.selectedSegmentIndex {
        case 0:
            receivemyDogGender = "남"
        case 1:
            receivemyDogGender = "여"
        case 2:
            receivemyDogGender = "중성화"
        default:
            receivemyDogGender = ""
        }

    }

    @IBAction func ModifyDang(_ sender: UIBarButtonItem) {
        print("insert DangInfo")
        
        
        receivemyDogName = tfMyDogName.text!
        receivemyDogSpecies = tfMyDogSpec.text!
        receivemyDogAge = tfMyDogAge.text!
        
//        print(imageURL!, petName!, petAge!,  petSpecies! , petGender!)
        
        let petModifyModel = PetModifyModel()
        petModifyModel.uploadImageFile(at: imageURL!, petName: receivemyDogName, petAge: receivemyDogAge, petSpecies: receivemyDogSpecies, petGender: receivemyDogGender, petId: receivemyDogId, completionHandler: {_,_ in
            print("Upload Success")
        })
        
        let resultAlert = UIAlertController(title: "완료", message: "수정이 되었습니다", preferredStyle: .alert)
        let onAction = UIAlertAction(title: "OK", style: .default, handler: {ACTION in

            self.navigationController?.popViewController(animated: true)
        })

        resultAlert.addAction(onAction)
        present(resultAlert, animated: true, completion: nil)
//        
//        if result {
//            let resultAlert = UIAlertController(title: "완료", message: "입력이 되었습니다", preferredStyle: .alert)
//            let onAction = UIAlertAction(title: "OK", style: .default, handler: {ACTION in
//
//                self.navigationController?.popViewController(animated: true)
//            })
//
//            resultAlert.addAction(onAction)
//            present(resultAlert, animated: true, completion: nil)
//
//        } else {
//            let resultAlert = UIAlertController(title: "완료", message: "에러가 발생 되었습니다", preferredStyle: .alert)
//            let onAction = UIAlertAction(title: "OK", style: .default, handler: {ACTION in
//                self.navigationController?.popViewController(animated: true)
//            })
//
//            resultAlert.addAction(onAction)
//            present(resultAlert, animated: true, completion: nil)
//        }
//        
        
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

extension ModifyPetViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            ivMyDog.image = image
            //업로드에 사용할 url
            imageURL = info[UIImagePickerController.InfoKey.imageURL] as? URL
            
            print(imageURL as Any)
        }
        dismiss(animated: true, completion: nil)
    }
    
}

extension ModifyPetViewController: UITextFieldDelegate ,UIPickerViewDelegate, UIPickerViewDataSource{
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
        tfMyDogSpec.text = everyDangSpecies[row]
    }
}
