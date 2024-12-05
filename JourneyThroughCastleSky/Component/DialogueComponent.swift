//
//  DialogueComponent.swift
//  JourneyThroughCastleSky
//
//  Created by Caio Marques on 18/09/24.
//

import Foundation

class DialogueComponent: Component {
    var dialogs : [Dialogue]
    
    init(dialogs: [Dialogue]) {
        self.dialogs = dialogs
    }
}
