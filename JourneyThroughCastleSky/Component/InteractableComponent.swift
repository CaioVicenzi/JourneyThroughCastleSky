//
//  InteractableComponent.swift
//  JourneyThroughCastleSky
//
//  Created by Caio Marques on 18/09/24.
//

import Foundation

class InteractableComponent: Component {
    func interact (_ completion : () -> Void) {
        completion()
    }
}
