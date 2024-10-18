//
//  HealthComponent.swift
//  JourneyThroughCastleSky
//
//  Created by Caio Marques on 18/09/24.
//

import Foundation

protocol HasHealth {
    var healthComponent: HealthComponent { get }
}

class HealthComponent: Component {
    var health : Int
    var maxHealth : Int
    
    init(health: Int) {
        self.health = health
        self.maxHealth = 100
    }
}
