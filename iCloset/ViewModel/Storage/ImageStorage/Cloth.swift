//
//  Cloth.swift
//  iCloset
//
//  Created by 송정훈 on 2021/04/03.
//

import Foundation
import UIKit
struct ClothItem{
    var cloth:Cloth
    var img:UIImage
    var createdTime:Date
    init(cloth:Cloth,img:UIImage,createdTime:Date){
        self.cloth = cloth
        self.img = img
        self.createdTime = createdTime
    }
}
struct Cloth{
    var name:String
    var brand:String
    var category:clothCategory
    var timeCreated:Date
    init(name:String,brand:String,category:clothCategory,timeCreated:Date){
        self.timeCreated = timeCreated
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
