//
//  ConsumableComponent.swift
//  JourneyThroughCastleSky
//
//  Created by Caio Marques on 18/09/24.
//

import Foundation

class ConsumableComponent {
    var nome : String
    var effect : Effect
    
    init(nome: String, effect: Effect) {
        self.nome = nome
        self.effect = effect
    }
}
