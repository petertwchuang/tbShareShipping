//
//  User.swift
//  taobaoWeight
//
//  Created by Peter on 2018/7/2.
//  Copyright © 2018年 Peter. All rights reserved.
//

import Foundation

public class User: NSObject
{
    var userID: Int = 0
    var name: String
    var personalFee: Float = 0.0
    var personalWeight: Float = 0.0
    
    init(userID: Int, name: String, fee: Float, weight: Float) {
        self.userID = userID
        self.name = name
        self.personalFee = fee
        self.personalWeight = weight
    }
    
    
}
