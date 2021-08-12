//
//  CommentImageModel.swift
//  dogtor
//
//  Created by SooHoon on 2021/08/13.
//

import Foundation

class CommentImageModel{
    var email: String
    var api: String
    var imagePath: String
    var nickName: String
    
    init(email: String, api: String, imagePath: String, nickName: String){
        self.email = email
        self.api = api
        self.imagePath = imagePath
        self.nickName = nickName
    }
    
    func printCommentImageAll(){
        print("email : \(email) \n apl: \(api) \n imagePath : \(imagePath) \n nickName: \(nickName)")
    }
  
}

