//
//  CommentInsertModel.swift
//  Rnd02
//
//  Created by SooHoon on 2021/08/05.
//

import Foundation

protocol CommentInsertProtocol {
    func insertDownload(comment: NSArray)
}

class CommentInsertModel{
    var delegate: CommentInsertProtocol!
    var urlPath = "http://\(myURL):8080/dogtor/comment_Insert.jsp"
    
    func insertGetComment(cWriter: String, cContent: String, fNo: Int){
        let urlAdd = "?cWriter=\(cWriter)&cContent=\(cContent)&fNo=\(fNo)"
        urlPath = urlPath + urlAdd
        
        urlPath = urlPath.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        
        let url = URL(string: urlPath)!
        let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)
        let task = defaultSession.dataTask(with: url){(data, response, error) in
            if error != nil{
                print("Failed to download data")
            }else{
                print("Data is inserted!")
                self.parseJson(data!)
            }
        }
        task.resume()
    }
    
    func parseJson(_ data: Data){
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
                print ("\(cNo) \n \(cWriter)")
                let query = CommentDBModel(cNo: cNo, cWriter: cWriter, cContent: cContent, cSubmitDate: cSubmitDate)
                locations.add(query) // append아님!! 주의 **************************
                query.printAll()
            }
        }
        DispatchQueue.main.async(execute: {() -> Void in
            self.delegate.insertDownload(comment: locations)
        })
    }
}

//class InsertModel{
//
//    var urlPath = "http://\(ipAdd):8080/iosFeed/comment_Insert.jsp"
//
//    func InsertItems(cWriter: String, cContent: String, fNo: Int) -> Bool{ // insert니까 값을 가지고 가야 이비에 넣어주니까 어트리뷰트 지정
//        var result : Bool = true
//        let urlAdd = "?cWriter=\(cWriter)&cContent=\(cContent)&fNo=\(fNo)"//겟방식으로 줄거임
//        // 얘가 진짜 사용되는 url
//        urlPath = urlPath + urlAdd
//
//        // 값이 한글일때 깨지니까, 그거 인코딩 해주자! >> 한글 url encoading
//        urlPath = urlPath.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
//
//        let url = URL(string: urlPath)!
//        let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)
//        let task = defaultSession.dataTask(with: url){(data, response, error) in
//            if error != nil{
//                print("Failed to download data")
//                result = false
//            }else{
//                print("Data is inserted!")
//                result = true
//            }
//        }
//        task.resume()
//        return result
//    }
//
//}
