//
//  WarningNewGame.swift
//  JourneyThroughCastleSky
//
//  Created by Caio Marques on 01/11/24.
//

import Foundation
import SpriteKit
import SwiftUI

class WarningNewGame {
    var buttonSelected : Int = 2
    let warningShape = SKShapeNode(rectOf: CGSize(width: 300, height: 250))
    var scene : MainMenuScene?
    @AppStorage("estage") var estage : Int = 0
    
    func config(_ scene : MainMenuScene) {
        self.scene = scene
    }
    
    func warning () {
        warningShape.position = PositionHelper.singleton.centralize(SKNode())
        warningShape.fillColor = .gray
        warningShape.zPosition = 2
        
        let warningLabel = SKLabelNode()
        warningLabel.text = "Isso vai apagar o seu progresso, tem certeza que deseja iniciar um novo jogo?"
        warningLabel.preferredMaxLayoutWidth = 230
        warningLabel.position = .zero
        warningLabel.position.y = 50
        warningLabel.fontSize = 10
        warningLabel.numberOfLines = 2
        
        warningShape.addChild(warningLabel)
        scene?.addChild(warningShape)
        
        let yesOption = SKShapeNode(rectOf: CGSize(width: 80, height: 40))
        yesOption.position = .zero
        yesOption.fillColor = .gray
        yesOption.name = "optionYes"
        
        let yesLabel = SKLabelNode(text: "Yes")
        yesLabel.fontName = "Helvetica-Bold"
        yesLabel.position = .zero
        yesLabel.fontSize = 14
        yesOption.addChild(yesLabel)
        
        warningShape.addChild(yesOption)
        
        
        
        let noOption = SKShapeNode(rectOf: CGSize(width: 80, height: 40))
        noOption.position = .zero
        noOption.position.y = -50
        noOption.fillColor = .gray
        noOption.name = "optionNo"
        
        let noLabel = SKLabelNode(text: "No")
        noLabel.fontName = "Helvetica-Bold"
        noLabel.position = .zero
        noLabel.fontSize = 14
        noOption.addChild(noLabel)
        
        warningShape.addChild(noOption)
        
        updateButtonColors()
    }
    
    func updateButtonColors () {
        let optionYes = warningShape.childNode(withName: "optionYes") as? SKShapeNode
        let optionNo = warningShape.childNode(withName: "optionNo") as? SKShapeNode
        
        optionYes?.fillColor = .gray
        optionNo?.fillColor = .gray
        
        if buttonSelected == 1 {
            optionYes?.fillColor = .red
        } else if buttonSelected == 2 {
            optionNo?.fillColor = .red
        }
    }
    
    func keyDown (_ event : NSEvent) {
        if event.keyCode == 0x7D {// seta para baixo
            down()
            updateButtonColors()
        }
        
        if event.keyCode == 0x7E { // seta para cima
            up()
            updateButtonColors()
        }
        
        if event.keyCode == 36 {
            if self.buttonSelected == 1 {
                self.estage = 0
                goMainHallScene()
            } else if self.buttonSelected == 2 {
                self.warningShape.removeFromParent()
                for child in warningShape.children {
                    child.removeFromParent()
                }
                self.buttonSelected = 1
                self.scene?.menuState = .CHOOSE_OPTION
            } else {
                print("Erro! O usuário conseguiu escolher outra opção sem ser 1 ou 2")
            }
        }
    }
    
    private func goMainHallScene () {
        if let scene = SKScene(fileNamed: "MainHallScene") as? MainHallScene {
            scene.scaleMode = .aspectFill
            let transition = SKTransition.fade(withDuration: 1.0)
            transition.pausesIncomingScene = false
            transition.pausesOutgoingScene = false
            self.scene?.view?.presentScene(scene, transition: transition)
        } else {
            print("Failed to load Cutscene.")
        }
    }
    
    func down () {
        if buttonSelected == 1 {
            buttonSelected += 1
        }
    }
    
    func up () {
        if buttonSelected == 2 {
            buttonSelected -= 1
        }
    }
    
}
