//
//  DialogSystem.swift
//  JourneyThroughCastleSky
//
//  Created by Caio Marques on 20/09/24.
//

import Foundation
import SpriteKit

class DialogSystem {
    var gameScene : GameScene!
    
    init() {}
    
    func config (_ gameScene : GameScene) {
        self.gameScene = gameScene
    }
    
    func nextDialogue () {
        gameScene.gameState = .NORMAL
        
        // limpar a dialog box
        gameScene.dialogueBox?.children.forEach({ node in
            node.removeFromParent()
        })
        
        if gameScene.dialogueBox?.parent != nil {
            gameScene.dialogueBox?.removeFromParent()
        }
        
        gameScene.unshowItemDescription()
        
        //
        if let dialog = gameScene.dialogsToPass.first {
            gameScene.gameState = .WAITING_DIALOG
            if gameScene.dialogueBox?.parent == nil {
                gameScene.setupDialogBox()
            }
            gameScene.addDialogToDialogBox(dialog)
            gameScene.dialogsToPass.removeFirst()
        } else {
            if let description = gameScene.descriptionsToPass.first {
                gameScene.gameState = .WAITING_DIALOG
                gameScene.showItemDescription(description)
                gameScene.descriptionsToPass.removeFirst()
            }
        }
    }
    
    func typeEffect (_ text : String, velocity : Int, label : SKLabelNode) {
        var index : Int = 0
        
        let milissecs = (Double(1) / Double(velocity))
        Timer.scheduledTimer(withTimeInterval: milissecs, repeats: true) { timer in
            nextChar()
        }
        
        func nextChar () {
            if index < text.count {
                let stringIndex = text.index(text.startIndex, offsetBy: index)
                label.text! += String(text[stringIndex])
                index += 1
            }
        }
    }
}
