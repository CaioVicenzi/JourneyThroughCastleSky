//
//  PhysicCategory.swift
//  JourneyThroughCastleSky
//
//  Created by Caio Marques on 25/09/24.
//

import Foundation

struct PhysicCategory {
    static let character : UInt32 = 0x1 << 0 //0001
    static let wall : UInt32 = 0x1 << 1 // 0010
    static let door : UInt32 = 0x1 << 2 // 0011
    static let enemy : UInt32 = 0x1 << 3 // 0100
}
