//
//  FriendlySystem.swift
//  JourneyThroughCastleSky
//
//  Created by Caio Marques on 30/09/24.
//

import Foundation

class FriendlySystem: System {
    var friendlies : [Friendly] = []
    var integerMaster : Int = 0
    let dialogueHelper = DialogHelper()
    let cutsceneHelper = CutsceneHelper()
    
    init(friendlies: [Friendly]) {
        self.friendlies = friendlies
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
            dialogue()
            GameProgressionSystem.singleton.upStage()
        }
    }
    
    func delieverCrystal () {
        // primeiramente verifica se o usuário tem algum cristal
        if User.singleton.inventoryComponent.itens.contains(where: { item in item.consumableComponent?.effect.type == .UP_LEVEL}) {
            User.singleton.inventoryComponent.itens.removeAll { item in item.consumableComponent?.effect.type == .UP_LEVEL}
            dialogue()
            GameProgressionSystem.singleton.upStage()
            
            if GameProgressionSystem.singleton.isMaxStage() {
                gameScene?.endGame()
            }
        } else {
            print("Não tem cristal para entregar")
        }
    }
    
    private func dialogue () {
        switch GameProgressionSystem.singleton.estage {
            case 0: firstInteraction()
            case 1: secondInteraction()
            case 2: thirdDialogue()
        default:
            break
        }
        gameScene?.dialogSystem.nextDialogue()
    }
    
    private func firstInteraction () {
        self.gameScene.dialogSystem.inputDialogs(dialogueHelper.firstDialogs)
        self.gameScene.cutsceneSystem.addCutscene(cutsceneHelper.cutsceneOne)
    }
    
    private func secondInteraction () {
        self.gameScene.dialogSystem.inputDialogs(dialogueHelper.secondDialogs)
        self.gameScene.cutsceneSystem.addCutscene(cutsceneHelper.cutsceneTwo)
        
    }
    
    private func thirdDialogue () {
        self.gameScene.dialogSystem.inputDialogs(dialogueHelper.thirdDialogs)
        self.gameScene.cutsceneSystem.addCutscene(cutsceneHelper.cutsceneThree)
    }
    
    func changeDialogueMaster() {
        integerMaster += 1
    }
}
