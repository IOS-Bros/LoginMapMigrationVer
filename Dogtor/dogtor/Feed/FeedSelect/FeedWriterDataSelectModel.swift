//
//  FeedWriterDataSelectModel.swift
//  dogtor
//
//  Created by 윤재필 on 2021/08/12.
//

import Foundation
import Alamofire

class FeedWriterDataSelectModel{
    let urlPath = "\(Common.jspPath)feed_writer_data_select.jsp"
    
    func requestWirterImage(nickName: String, completion: @escaping(String?) -> (Void)) {
        print("@@@ requestWirterImage send nick : \(nickName)")
        guard let url: URL = URL(string: urlPath+"?nickName=\(nickName)") else {
            print("feedDownloaded() : URL is not avilable")
            return
        }
        let header: HTTPHeaders = ["Content-Type":"application/json"]
        let dataRequest = AF.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: header)
        
        dataRequest.responseData {(response) in
            switch response.result {
            case .success:
                guard let data = response.value else {
                    print("Failed to download data")
                    return
                }
                guard let returnData = String(data: data, encoding: .utf8) else{
                    print("data is being. but load error")
                    return
                }
                
                if returnData == "none" {
                    print("data is nil")
                    return
                }
                print("@@@ requestWirterImage data : \(returnData.trimmingCharacters(in: .whitespacesAndNewlines))")
                completion(returnData.trimmingCharacters(in: .whitespacesAndNewlines))
                
            case .failure(let err):
                print(err)
            }
        }
    }//requestWirterImage
    
   
}//FeedSelectAllModel
