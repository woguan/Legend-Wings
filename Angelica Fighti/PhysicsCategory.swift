//
//  Structs.swift
//  Angelica Fighti
//
//  Created by Guan Wong on 12/30/16.
//  Copyright © 2016 Wong. All rights reserved.
//

import Foundation

struct PhysicsCategory {
    static let None      : UInt32 = 0
    static let Imune       : UInt32 = UInt32.max
    static let Player   :UInt32 = 0b10
    static let Enemy   : UInt32 = 0b100
    static let Projectile : UInt32 = 0b1000
    static let Currency : UInt32 = 0b10000
    static let Wall: UInt32 = 0b1000000
}
