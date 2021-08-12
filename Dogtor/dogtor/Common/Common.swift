//
//  Common.swift
//  dogtor
//
//  Created by 윤재필 on 2021/08/06.
//

import Foundation

class Common{
    static let ipAddr = "192.168.0.11"
    static let jspPath = "http://\(ipAddr):8080/dogtor/"
    static let feedImagePath = "http://\(ipAddr):8080/dogtor/feedImage/"
    static let writerImagePath = "http://\(ipAddr):8080/dogtor/userImage/"
    static let userInfo = UserDBModel()
}
