//
//  PetDeleteModel.swift
//  dogtor
//
//  Created by SeungYeon on 2021/08/06.
//

import Foundation
//class JsonModel:NSObject{
class PetDeleteModel{
    var urlPath = "http://\(myURL):8080/dogtor/petDelete.jsp"
    
    func deletePet(petId: String) -> Bool{
        var result: Bool = true
        let urlAdd = "?petId=\(petId)"
        urlPath = urlPath + urlAdd
        print(urlPath)
        // 한글 url encoding
        urlPath = urlPath.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        
        let url: URL = URL(string: urlPath)!
        let defaultSesstion = URLSession(configuration: URLSessionConfiguration.default)
        let task = defaultSesstion.dataTask(with: url){(data, response, error) in
            if error != nil{
                print("Failed to delete data")
                result = false
            }else{
                print("Data is deleted!")
                result = true
            }
            
        }
        task.resume()
        return result
    }
    
}
