//
//  WarningNewGame.swift
//  JourneyThroughCastleSky
//
//  Created by Caio Marques on 01/11/24.
//

import Foundation
import SpriteKit

class WarningNewGame {
    var buttonSelected : Int = 1
    let warningShape = SKShapeNode(rectOf: CGSize(width: 300, height: 150))
    var scene : SKScene?
    
    func config(_ scene : SKScene) {
        self.scene = scene
    }
    
    func warning () {
        warningShape.position = PositionHelper.singleton.centralize(SKNode())
        warningShape.fillColor = .gray
        warningShape.zPosition = 2
        
        let warningLabel = SKLabelNode()
        warningLabel.text = "Isso vai apagar o seu progresso, tem certeza que deseja iniciar um novo jogo?"
        warningLabel.preferredMaxLayoutWidth = 250
        warningLabel.position = .zero
        warningLabel.position.y = 0
        warningLabel.fontSize = 10
        warningLabel.numberOfLines = 2
        
        warningShape.addChild(warningLabel)
        scene?.addChild(warningShape)
        
        let yesOption = SKShapeNode(rectOf: CGSize(width: 80, height: 40))
        yesOption.position = .zero
        yesOption.position.y -= 100
        yesOption.position.x += 50
        yesOption.fillColor = .gray
        yesOption.name = "optionYes"
        warningLabel.addChild(yesOption)
        
        
        
        let noOption = SKShapeNode(rectOf: CGSize(width: 80, height: 40))
        noOption.position = .zero
        noOption.position.y -= 100
        noOption.position.x -= 50
        noOption.fillColor = .gray
        noOption.name = "optionNo"

        warningLabel.addChild(noOption)
        
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
    
    func down () {
        if buttonSelected == 2 {
            buttonSelected = 1
        }
    }
    
    func up () {
        if buttonSelected == 1 {
            buttonSelected = 2
        }
    }
    
}
