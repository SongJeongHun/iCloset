//
//  User.swift
//  iCloset
//
//  Created by 송정훈 on 2021/03/14.
//

import Foundation
struct User{
    var userID:String
    var userPassword:String
    var userEmail:String
    init(userID:String,userPassword:String,userEmail:String){
        self.userID = userID
        self.userPassword = userPassword
        self.userEmail = userEmail
    }
}
enum UserError:Error{
    case userPasswordMissing
    case userIDMissing
}

