//
//  FriendlySystem.swift
//  JourneyThroughCastleSky
//
//  Created by Caio Marques on 30/09/24.
//

import Foundation

class FriendlySystem {
    var gameScene : TopDownScene? = nil
    var friendlies : [Friendly] = []
    
    init(friendlies: [Friendly]) {
        self.friendlies = friendlies
    }
    
    func config (_ gameScene : TopDownScene) {
        self.gameScene = gameScene
    }
    
    func isFriendlyNearUser (_ friendly : Friendly) -> Bool {
        return PositionSystem.isOtherNearPlayer(friendly.positionComponent, range: 50)
    }
    
    func isAnyFriendlyNear () -> Bool {
        var isAnyNear = false
        
        friendlies.forEach { friendly in
            if isFriendlyNearUser(friendly) {
                isAnyNear = true
            }
        }
        
        return isAnyNear
    }
    
    func talkToNearestFriendly () {
        friendlies.forEach { friendly in
            if isFriendlyNearUser(friendly) {
                gameScene?.dialogSystem.inputDialogs(friendly.dialogueComponent.dialogs)
                gameScene?.dialogSystem.nextDialogue()
            }
        }
    }
}
