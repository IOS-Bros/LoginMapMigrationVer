//
//  CommentSelectQueryModel.swift
//  Rnd02
//
//  Created by SooHoon on 2021/08/05.
//

import Foundation

protocol CommentSelectProtocol {
    func commentDownload(comment: NSArray)
}

class CommentSelectModel{
    var delegate: CommentSelectProtocol!
    var urlPath = "http://\(myURL):8080/dogtor/comment_Select.jsp"
    
    func getComment(fNo: Int){
        let urlAdd = "?fNo=\(fNo)"
        urlPath = urlPath + urlAdd
        
        urlPath = urlPath.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        
        let url = URL(string: urlPath)!
        let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)
        let task = defaultSession.dataTask(with: url){(data, response, error) in
            if error != nil{
                print("Failed to download data")
            }else{
                print("Data is Selcted!")
                self.parseJson(data!)
            }
        }
        task.resume()
    }
    
    func parseJson(_ data: Data){
        if let returnData = String(data: data, encoding: .utf8) {
            print(returnData)
        } else {
            print("data is empty")
            
        }
        print(" ^ ^ ^ ^ ^ ^ ^ ^ ^ ^ ^ ^ ^ ^ ^ ^")
        var jsonResult = NSArray()
        
        do{
            jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! NSArray
        }catch let error as NSError{
            print("Error: \(error)")
        }
        
        var jsonElement = NSDictionary()
        let locations = NSMutableArray()
        
        for i in 0..<jsonResult.count{
            
            jsonElement = jsonResult[i] as! NSDictionary
            
            if let cNo = jsonElement["cNo"] as? String, // if let쓰기
               let cWriter = jsonElement["cWriter"] as? String,
               let cSubmitDate = jsonElement["cSubmitDate"] as? String,
               let cContent = jsonElement["cContent"] as? String{
               let query = CommentDBModel(cNo: cNo, cWriter: cWriter, cContent: cContent, cSubmitDate: cSubmitDate)
                locations.add(query) // append아님!! 주의 **************************
                query.printAll()
            }
        }
        DispatchQueue.main.async(execute: {() -> Void in
            self.delegate.commentDownload(comment: locations)
        })
    }
}
