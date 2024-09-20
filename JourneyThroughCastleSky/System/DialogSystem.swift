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
        gameScene.dialogueBox?.children.forEach({ node in
            node.removeFromParent()
        })
        
        if gameScene.dialogueBox?.parent != nil {
            gameScene.dialogueBox?.removeFromParent()
        }
        
        
        if let dialog = gameScene.dialogsToPass.first {
            gameScene.gameState = .WAITING_DIALOG
            if gameScene.dialogueBox?.parent == nil {
                gameScene.setupDialogBox()
            }
            gameScene.addDialogToDialogBox(dialog)
            gameScene.dialogsToPass.removeFirst()
        }
    }
    
    func typeEffect (_ dialog : Dialogue, label : SKLabelNode) {
        var index : Int = 0
        
        let milissecs = (Double(1) / Double(dialog.velocity))
        Timer.scheduledTimer(withTimeInterval: milissecs, repeats: true) { timer in
            nextChar()
        }
        
        func nextChar () {
            if index < dialog.text.count {
                let stringIndex = dialog.text.index(dialog.text.startIndex, offsetBy: index)
                label.text! += String(dialog.text[stringIndex])
                index += 1
            }
        }
    }
}
