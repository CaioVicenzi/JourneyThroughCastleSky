//
//  DialogSystem.swift
//  JourneyThroughCastleSky
//
//  Created by Caio Marques on 20/09/24.
//

import Foundation
import SpriteKit

class DialogSystem: System {
    private var dialogsToPass : [Dialogue] = []
    private var dialogsToPassAfterCutscene : [Dialogue] = []

    func next () {
        // troca o gameState e o mostRecentMove para um array vazio para fazer o usuário instantaneamente parar
        gameScene.movementSystem.mostRecentMove = []
        gameScene.gameState = .NORMAL
        
        // limpar a descrição de item ou a caixa de diálogo se tiver um dos dois.
        cleanDialogBox()
        gameScene.cleanItemDescription()
        
        if self.gameScene.dialogSystem.dialogsToPass.first != nil {
            nextDialog()
        } else if self.gameScene.descriptionsToPass.first != nil {
            nextItemDescription()
        } else if self.gameScene.cutsceneSystem.cutscenes.first != nil {
            nextCutscene()
        } else if self.gameScene.dialogSystem.dialogsToPassAfterCutscene.first != nil {
            nextDialogAfterCutscene()
        } else {
            self.gameScene.gameState = .NORMAL
        }
    }
    
    private func cleanDialogBox () {
        // limpar a dialog box
        gameScene.dialogueBox?.children.forEach({ node in
            node.removeFromParent()
        })
        
        if gameScene.dialogueBox?.parent != nil {
            gameScene.dialogueBox?.removeFromParent()
        }
    }
    
    func inputDialogs (_ dialogues: [Dialogue]) {
        self.dialogsToPass.append(contentsOf: dialogues)
    }
    
    func inputDialogsAfterCutscene (_ dialogues : [Dialogue]) {
        self.dialogsToPass.append(contentsOf: dialogues)
    }
    
    func nextDialog() {
        if let firstDialogue = dialogsToPass.first {
            gameScene.gameState = .WAITING_DIALOG
            if gameScene.dialogueBox?.parent == nil {
                gameScene.setupDialogBox()
            }
            gameScene.addDialogToDialogBox(firstDialogue)
            self.dialogsToPass.removeFirst()
        }
    }
    
    func nextItemDescription () {
        if let description = gameScene.descriptionsToPass.first {
            gameScene.gameState = .WAITING_DIALOG
            gameScene.showItemDescription(description)
            gameScene.descriptionsToPass.removeFirst()
        }
    }
    
    func nextCutscene () {
        if let cutscene = gameScene.cutsceneSystem.cutscenes.first {
            gameScene.cutsceneSystem.nextCutscene()
        }
    }
    
    func nextDialogAfterCutscene () {
        if let firstDialogue = gameScene.dialogSystem.dialogsToPassAfterCutscene.first {
            gameScene.gameState = .WAITING_DIALOG
            if gameScene.dialogueBox?.parent == nil {
                gameScene.setupDialogBox()
            }
            gameScene.addDialogToDialogBox(firstDialogue)
            self.dialogsToPassAfterCutscene.removeFirst()
        }
    }
    
    func inputDialog (_ text : String, person : String, velocity : Int = 10) {
        let dialogue = Dialogue(text: text, person: person, velocity: velocity)
        self.dialogsToPass.append(dialogue)
    }
    
    static func typeEffect (_ text : String, velocity : Int, label : SKMultilineLabel,_ completionHandler: @escaping () -> Void) {
        var i : Int = 0
        
        let milissecs = (Double(1) / Double(velocity))
        Timer.scheduledTimer(withTimeInterval: milissecs, repeats: true) { timer in
            if i < text.count {
                let stringIndex = text.index(text.startIndex, offsetBy: i)
                label.text += String(text[stringIndex])
                i += 1
            } else {
                // ACABOU
                completionHandler()
                timer.invalidate()
            }
        }
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
            next()
        }
    }
}
