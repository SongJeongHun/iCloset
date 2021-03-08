//
//  TransitionStyle.swift
//  iCloset
//
//  Created by 송정훈 on 2021/03/08.
//

import Foundation
enum TransitionStyle{
    case modal
    case root
    case push
}
enum TransitionError:Error{
    case cannotPop
    case navigationMissing
    case unKnownError
}
