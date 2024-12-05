//
//  Entity.swift
//  JourneyThroughCastleSky
//
//  Created by João Ângelo on 27/09/24.
//

import Foundation

class Entity {

    var components: [Component] = []

    func addComponent(_ component: Component) {
        if let index = components.firstIndex(where: { comp in
            return type(of: component) == type(of: comp)
        }) {
            components.remove(at: index)
        }

        components.append(component)
    }

    func getComponent(_ component: Component.Type) -> Component? {
        return components.first(where: { comp in
            return component == type(of: comp)
        })
    }
}
