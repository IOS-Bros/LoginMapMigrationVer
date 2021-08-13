//
//  CommentImageSelctModel.swift
//  dogtor
//
//  Created by SooHoon on 2021/08/13.
//

import Foundation

protocol CommenteSelectModelProtocol{
    func CommentImageDownloaded(items: NSMutableArray)
}


class CommentImageSelectModel{
    var delegate: CommenteSelectModelProtocol!
    var urlPath = "http://\(Share.myURL):8080/dogtor/comment_Image_Select.jsp"
    
    func getCommentImage(cNickName: String, complation: @escaping (String?) -> (Void)){
        let urlAdd = "?nickName=\(cNickName)"
        urlPath = urlPath + urlAdd
        print("commentImagePath : \(urlPath)")
        
        urlPath = urlPath.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        
        guard let url: URL = URL(string: urlPath) else {
            print("feedDownloaded() : URL is not avilable")
            return
        }
        
        let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)
        let task = defaultSession.dataTask(with: url){(data, responds, error) in
            if error != nil{
                print("Failed to download data")
            } else {
                print("Data is download")
                let image = self.parseJSON(data!)
                complation(image.trimmingCharacters(in: .whitespacesAndNewlines)
            
            )}
        }
        task.resume()
    }//feedDownloaded
    
    func parseJSON(_ data: Data) -> String {
        print("CommentImageParse")
        if let returnData = String(data: data, encoding: .utf8) {
            print(returnData)
        } else {
            print("data is empty")
            
        }
        print("--------------------")
        
        var jsonResult = NSArray()
        
        do{
            jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! NSArray
        }catch let error as NSError {
            print(error)
        }
        
        var jsonElement = NSDictionary()
        var locations = NSMutableArray()
        
        for i in 0..<jsonResult.count{
            jsonElement = jsonResult[i] as! NSDictionary
            if let email = jsonElement["email"] as? String,
               let api = jsonElement["api"] as? String,
               let imagePath = jsonElement["imagePath"] as? String,
               let nickName = jsonElement["nickName"] as? String{
                let dto = CommentImageModel(email: email, api: api, imagePath: imagePath, nickName: nickName)
                dto.printAll()
                locations.add(dto)
                
                return imagePath
            }
        }
        return "none"
        DispatchQueue.main.async(execute: {() -> Void in
            self.delegate.CommentImageDownloaded(items: locations)
        })
    }//parseJSON
}
