//
//  OptionsMenu.swift
//  JourneyThroughCastleSky
//
//  Created by Caio Marques on 11/11/24.
//

import Foundation
import SpriteKit

extension Inventory {
    func setupOptions () {
        optionsBackground = SKShapeNode(rectOf: CGSize(width: gameScene.size.width / 1.2, height: gameScene.size.height / 1.8))
        optionsBackground?.position = .zero
        optionsBackground?.fillColor = .clear
        optionsBackground?.strokeColor = .clear
        optionsBackground?.position.y -= 50

        if let optionsBackground {
            inventory?.addChild(optionsBackground)
        }
        
        optionsBackground?.isHidden = true
        
        setupLittleButton ("TELA DE TÍTULO", number: 1, background: optionsBackground)
        setupLittleButton ("SAIR DO JOGO", number: 2, background: optionsBackground)
        setupLittleButton ("CONFIGURAÇÕES", number: 3, background: optionsBackground)
         
    }
    
    private func setupLittleButton (_ title : String, number : Int, background : SKShapeNode?) {
        let baseButton = SKSpriteNode(imageNamed: "buttonUnselected")
        baseButton.position = .zero
        let yPosition : Double
        
        switch number {
            case 1: yPosition = 100
            case 2: yPosition = .zero
            case 3: yPosition = -100
            default: yPosition = .zero
        }
        
        baseButton.position.y = yPosition
        baseButton.zPosition = 6
        baseButton.name = "optionButton\(number)"
        
        let proportion = 75 / baseButton.frame.height
        baseButton.setScale(proportion)
        
        background?.addChild(baseButton)
        
        let buttonText = SKLabelNode(text: title)
        buttonText.fontName = "Lora-Medium"
        buttonText.fontSize = 32
        buttonText.fontColor = .black
        buttonText.position = .zero
        buttonText.position.y -= baseButton.frame.height / 5
        buttonText.zPosition = 7
        baseButton.addChild(buttonText)
        
        
    }
    
    func updateOptions () {
        guard let inventory = self.optionsBackground else {
            print("Não temos inventory no Inventory")
            return
        }
        
        for child in inventory.children {
            if let childName = child.name {
                if childName.starts(with: "optionButton") {
                    if childName == "optionButton\(self.optionsOptionsSelected)" {
                        let novoButton = SKSpriteNode(imageNamed: "buttonSelected")
                        novoButton.size = child.frame.size
                        novoButton.position = child.position
                        novoButton.name = childName
                        child.removeFromParent()
                        for childChildren in child.children {
                            childChildren.removeFromParent()
                            novoButton.addChild(childChildren)
                        }

                        inventory.addChild(novoButton)
                    } else {
                        let novoButton = SKSpriteNode(imageNamed: "buttonUnselected")
                        novoButton.size = child.frame.size
                        novoButton.position = child.position
                        novoButton.name = childName
                        child.removeFromParent()
                        for childChildren in child.children {
                            childChildren.removeFromParent()
                            novoButton.addChild(childChildren)
                        }

                        inventory.addChild(novoButton)
                    }
                }
            }
        }
    }
    
    
    
    func setupConfigurations () {
        
        
        /*
        gameScene.childNode(withName: "optionButton1")?.removeFromParent()
        gameScene.childNode(withName: "optionButton2")?.removeFromParent()
        gameScene.childNode(withName: "optionButton3")?.removeFromParent()
        
        let configRectangle = SKSpriteNode(imageNamed: "itensSession")
        let scale = (gameScene.size.width / 1.5) / configRectangle.frame.width
        configRectangle.setScale(scale)
        configRectangle.position = .zero
        configRectangle.zPosition = 8
        gameScene.addChild(configRectangle)
         */
    }
}
