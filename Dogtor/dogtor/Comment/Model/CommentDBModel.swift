//
//  CommentDBModel.swift
//  Rnd02
//
//  Created by SooHoon on 2021/08/05.
//

import Foundation

class CommentDBModel: NSObject{
    var cNo: String?
    var cWriter: String?
    var cContent: String?
    var cSubmitDate: String?

    override init() {
        
    }
    
    init(cNo: String, cWriter: String, cContent: String, cSubmitDate: String) {
        self.cNo = cNo
        self.cWriter = cWriter
        self.cContent = cContent
        self.cSubmitDate = cSubmitDate
        
    }
   
   
    func printAll(){
        print("no : \(cNo), writer : \(cWriter), content : \(cContent), submitdate : \(cSubmitDate)")
    }
    
}
