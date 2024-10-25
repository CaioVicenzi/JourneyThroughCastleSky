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
    var integerMaster : Int = 0
    
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
                talkToFriendly(friendly)
            }
        }
    }
    
    private func talkToFriendly (_ friendly : Friendly) {
        if GameProgressionSystem.singleton.estage > 0 {
            delieverCrystal()
        } else {
            GameProgressionSystem.singleton.upStage()
            dialogue()
        }
    }
    
    func delieverCrystal () {
        // primeiramente verifica se o usuário tem algum cristal
        if User.singleton.inventoryComponent.itens.contains(where: { item in item.consumableComponent?.effect.type == .UP_LEVEL}) {
            User.singleton.inventoryComponent.itens.removeAll { item in item.consumableComponent?.effect.type == .UP_LEVEL}
            dialogue()
            GameProgressionSystem.singleton.upStage()

        } else {
            print("Não tem cristal para entregar")
        }
    }
    
    private func dialogue () {
        var dialogueSequence : [Dialogue] = []
        
        switch GameProgressionSystem.singleton.estage {
        case 0:
            dialogueSequence = [Dialogue(text: "Primeiro diálogo: vai pegar o cristal", person: "Weerdman", velocity: 50)]
        case 1:
            dialogueSequence = [Dialogue(text: "Segundo diálogo, vai pegar mais um cristal para mim", person: "Weerdman", velocity: 50)]
        case 2:
            dialogueSequence = [Dialogue(text: "Terceiro diálogo, obrigado pelos cristais, otário", person: "Weerdman", velocity: 50)]
        default:
            break
        }
        
        self.gameScene?.dialogSystem.inputDialogs(dialogueSequence)
        gameScene?.dialogSystem.nextDialogue()
    }
    
    func changeDialogueMaster() {
        integerMaster += 1
    }
}
