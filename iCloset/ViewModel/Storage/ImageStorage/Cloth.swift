//
//  Cloth.swift
//  iCloset
//
//  Created by 송정훈 on 2021/04/03.
//

import Foundation
struct Cloth{
    var name:String
    var brand:String
    var category:clothCategory
    init(name:String,brand:String,category:clothCategory){
        self.name = name
        self.brand = brand
        self.category = category
    }
}
enum clothCategory{
    case top
    case bottom
    case acc
    case shoe
}
