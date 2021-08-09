//
//  PetInsertModel.swift
//  dogtor
//
//  Created by Jasper Oh on 2021/08/05.
//

import Foundation


class PetInsertModel: NSObject {
    
    var urlPath = "http://\(myURL):8080/dogtor/petInsert.jsp"
    
//    print(imageURL!, petName!, petAge! ,  petSpecies! , petGender! , userEmail)
    
    func insertPet(_ imageURL : URL, _ petName : String, _ petAge : String, _ petSpecies : String , _ petGender : String , _ userEmail : String) -> Bool {
        
        var result : Bool = true
        let urlAdd = "?imageURL=\(imageURL)&petName=\(petName)&petAge=\(petAge)&petSpecies=\(petSpecies)&petGender=\(petGender)&userEmail=\(userEmail)"
        
        urlPath = urlPath + urlAdd
        
        urlPath = urlPath.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        
        print(urlPath)
        
        let url : URL = URL(string: urlPath)!
        let defaultSession = URLSession(configuration: URLSessionConfiguration.default)
        let task = defaultSession.dataTask(with: url) {(data, response, error) in
            if error != nil {
                print("Failed to insert data")
                result = false
            } else {
                print("Data is inserted!")
                result = true
                
            }
            
        }
        task.resume()
        return result
    }
}
