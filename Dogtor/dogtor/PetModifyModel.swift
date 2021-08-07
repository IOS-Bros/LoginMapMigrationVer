//
//  PetModifyModel.swift
//  dogtor
//
//  Created by SeungYeon on 2021/08/06.
//

import Foundation
//class JsonModel:NSObject{
class PetModifyModel{
    var urlPath = "http://\(myURL):8080/dogtor/petModify.jsp"
    
    func modifyPet(_ imageURL : URL, _ petName : String, _ petAge : String, _ petSpecies : String , _ petGender : String , _ petId : String) -> Bool{
        var result: Bool = true
        let urlAdd = "?imageURL=\(imageURL)&petName=\(petName)&petAge=\(petAge)&petSpecies=\(petSpecies)&petGender=\(petGender)&petId=\(petId)"
        urlPath = urlPath + urlAdd
        
        // 한글 url encoding
        urlPath = urlPath.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        
        let url: URL = URL(string: urlPath)!
        let defaultSesstion = URLSession(configuration: URLSessionConfiguration.default)
        let task = defaultSesstion.dataTask(with: url){(data, response, error) in
            if error != nil{
                print("Failed to update data")
                result = false
            }else{
                print("Data is updated!")
                result = true
            }
            
        }
        task.resume()
        return result
    }
    
}
