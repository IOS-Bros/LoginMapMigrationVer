//
//  CommentDeleteModel.swift
//  Rnd02
//
//  Created by SooHoon on 2021/08/05.
//

import Foundation

class DeleteModel{

    var urlPath = "http://\(myURL):8080/dogtor/comment_Delete.jsp"
    
    func DeleteItems(cNo: String) -> Bool{ // insert니까 값을 가지고 가야 이비에 넣어주니까 어트리뷰트 지정
        var result : Bool = true
        let urlAdd = "?cNo=\(cNo)"//겟방식으로 줄 것.
        // 얘가 진짜 사용되는 url
        urlPath = urlPath + urlAdd
        
        // 값이 한글일때 깨지니까, 그거 인코딩 해주자! >> 한글 url encoading
        urlPath = urlPath.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        
        let url = URL(string: urlPath)!
        let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)
        let task = defaultSession.dataTask(with: url){(data, response, error) in
            if error != nil{
                print("Failed to download data")
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
