//
//  DialogSystem.swift
//  JourneyThroughCastleSky
//
//  Created by Caio Marques on 20/09/24.
//

import Foundation
import SpriteKit

class DialogSystem {
    var gameScene : TopDownScene!
    private var dialogsToPass : [Dialogue] = []
    
    init() {}
    
    func config (_ gameScene : TopDownScene) {
        self.gameScene = gameScene
    }
    
    func nextDialogue () {
        gameScene.movementSystem.mostRecentMove = []
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
        if let dialog = self.dialogsToPass.first {
            gameScene.gameState = .WAITING_DIALOG
            if gameScene.dialogueBox?.parent == nil {
                gameScene.setupDialogBox()
            }
            gameScene.addDialogToDialogBox(dialog)
            self.dialogsToPass.removeFirst()
        } else {
            if let description = gameScene.descriptionsToPass.first {
                gameScene.gameState = .WAITING_DIALOG
                gameScene.showItemDescription(description)
                gameScene.descriptionsToPass.removeFirst()
            } else {
                gameScene.gameState = .NORMAL
            }
        }
    }
    
    func inputDialogs (_ dialogues: [Dialogue]) {
        self.dialogsToPass.append(contentsOf: dialogues)
    }
    
    func inputDialog (_ text : String, person : String, velocity : Int = 10) {
        let dialogue = Dialogue(text: text, person: person, velocity: velocity)
        self.dialogsToPass.append(dialogue)
    }
    
    static func typeEffect (_ text : String, velocity : Int, label : SKLabelNode,_ completionHandler: @escaping () -> Void) {
        var i : Int = 0
        
        let milissecs = (Double(1) / Double(velocity))
        Timer.scheduledTimer(withTimeInterval: milissecs, repeats: true) { timer in
            if i < text.count {
                let stringIndex = text.index(text.startIndex, offsetBy: i)
                label.text! += String(text[stringIndex])
                i += 1
            } else {
                // ACABOU
                completionHandler()
                timer.invalidate()
            }
        }
    }
    
    func input (_ keyCode : UInt16) {
        let isEnterKey = keyCode == 36

        if isEnterKey {
            nextDialogue()
        }
    }
}
