//
//  UserDBModel.swift
//  dogtor
//
//  Created by 예쁘고 비싼 thㅡ레기 on 2021/08/03.
//

import Foundation

class UserDBModel : NSObject {
    var userId : String?
    var API : String?
    var email : String?
    var image : String?
    var nickName : String?
    
    var imageURL : URL?
    
    override init() {
        
    }
    
    init(API : String, email : String) {
        self.API = API
        self.email = email
    }
    // 20210805 - yejin
    init(nickName : String) {
        self.nickName = nickName
    }
    // --
}
