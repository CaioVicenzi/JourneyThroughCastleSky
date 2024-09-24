//
//  MovementComponent.swift
//  JourneyThroughCastleSky
//
//  Created by Caio Marques on 18/09/24.
//

import Foundation

class MovementComponent: Component {
    var velocity : Int
    var moveX : Int
    var moveY : Int
    
    init(velocity: Int) {
        self.velocity = velocity
        self.moveX = 0
        self.moveY = 0
    }
}
