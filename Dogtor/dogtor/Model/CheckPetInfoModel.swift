//
//  CheckPetInfoModel.swift
//  dogtor
//
//  Created by Jasper Oh on 2021/08/05.
//

import Foundation

// 값을 다른곳으로 줄때 쓰는것
protocol CheckPetInfoModelProtocol : AnyObject {
    func petInfoDownloaded(items : NSMutableArray)
}

class CheckPetInfoModel : NSObject {
   
    var delegate : CheckPetInfoModelProtocol!
    
    
    func checkPet(_ email : String) {
        let urlPath = "http://\(myURL):8080/dogtor/checkPet.jsp?email=\(email)"
        print(urlPath)
        let url : URL = URL(string: urlPath)!
        let defaultSession = URLSession(configuration: URLSessionConfiguration.default)
        let task = defaultSession.dataTask(with: url) {(data, response, error) in
            if error != nil {
                print("Failed to download data")
            } else {
                print("Data is downloaded")
                self.parseJSON(data!)
            }
            
        }
        task.resume()
    }
    
    func parseJSON(_ data : Data) {
        print("parseJSON")
        var jsonResult = NSArray()
        do {
            jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! NSArray
        } catch let error as NSError {
            print("여기가 에러!  \(error) ")
        }
        
        var jsonElement = NSDictionary()
        let locations = NSMutableArray()
        
        
        
        for i in 0..<jsonResult.count {
                print("HAHA")
                jsonElement = jsonResult[i] as! NSDictionary
                if let PetId = jsonElement["PetId"] as? String,
                   let PetName = jsonElement["PetName"] as? String,
                   let PetImage = jsonElement["PetImage"] as? String,
                   let PetSpecies = jsonElement["PetSpecies"] as? String,
                   let PetGender = jsonElement["PetGender"] as? String,
                   let PetAge = jsonElement["PetAge"] as? String{
                    print("Model : \(PetId)")
                    let query = PetDBModel(PetId: PetId, PetName: PetName, PetImage: PetImage, PetSpecies: PetSpecies, PetGender: PetGender, PetAge: PetAge)
                    locations.add(query)
                }
            }
        
        
        
        
        
//         다른 일을 할때를 대비하여 async를 사용한다.
//        DispatchQueue.main.async(execute: {() -> Void in
            self.delegate.petInfoDownloaded(items: locations)
//        })
    }
    
}
