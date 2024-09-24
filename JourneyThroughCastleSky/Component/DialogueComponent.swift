//
//  DialogueComponent.swift
//  JourneyThroughCastleSky
//
//  Created by Caio Marques on 18/09/24.
//

import Foundation

// componente de qualquer elemento que pode fazer com que apareçam diálogos
class DialogueComponent {
    var dialogs : [Dialogue]
    
    init(dialogs: [Dialogue]) {
        self.dialogs = dialogs
    }
}
