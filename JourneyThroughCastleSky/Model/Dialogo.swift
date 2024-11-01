//
//  Dialogo.swift
//  JourneyThroughCastleSky
//
//  Created by Caio Marques on 17/09/24.
//

import Foundation

struct Dialogue {
    var text : String
    var person : String
    var velocity : Int
    
    init(text: String, person: String, velocity: Int = 50) {
        self.text = text
        self.person = person
        self.velocity = velocity
    }
}
