//
//  OptionsMenu.swift
//  JourneyThroughCastleSky
//
//  Created by Caio Marques on 11/11/24.
//

import Foundation
import SpriteKit

class OptionsMenu {
    // VARIÁVEIS RECEBIDAS DE PARÂMETRO
    var optionsBackground : SKShapeNode?
    var gameScene : TopDownScene
    var pause : Pause
    
    // VARIÁVEL DE CONTROLE DE INPUT
    var optionsSelected : Int = 1
    
    // VARIÁVEL DE APOIO PARA CRIAR A CONFIGURATION.
    var configurations : Configurations?
    
    init(_ pause : Pause) {
        self.gameScene = pause.gameScene
        self.pause = pause
    }
    
    func setupOptions () {
        optionsBackground = SKShapeNode(rectOf: CGSize(width: gameScene.size.width / 1.2, height: gameScene.size.height / 1.8))
        
        optionsBackground?.position = .zero
        optionsBackground?.fillColor = .clear
        optionsBackground?.strokeColor = .clear
        optionsBackground?.position.y -= 50

        if let optionsBackground {
            pause.pauseBackground?.addChild(optionsBackground)
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
                    if childName == "optionButton\(self.optionsSelected)" {
                        let novoButton = SKSpriteNode(imageNamed: "buttonSelected")
                        novoButton.size = child.frame.size
                        novoButton.position = child.position
                        novoButton.name = childName
                        for childChildren in child.children {
                            childChildren.removeFromParent()
                            novoButton.addChild(childChildren)
                        }
                        
                        child.removeFromParent()
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
    
    func input(_ keyCode : Int) {
        let isEnterKey = keyCode == 36
        let isEscKey = keyCode == 53
        let isUpArrow = keyCode == 126
        let isDownArrow = keyCode == 125
        
        if isUpArrow {
            if optionsSelected > 1 {
                optionsSelected -= 1
            }
        }

        if isDownArrow {
            if optionsSelected < 3 {
                optionsSelected += 1
            }
        }
        
        if isEscKey {
            pause.pauseState = .NORMAL
        }
        
        if isEnterKey {
            switch optionsSelected {
                case 1: titleScreenButtonPressed()
                case 2: exitGameButtonPressed()
                case 3: configurationsButtonPressed()
                default: break
            }
        }
    }
    
    
    private func titleScreenButtonPressed() {
        // tem certeza que quer sair do jogo?
    }
    
    private func exitGameButtonPressed () {
        guard let optionsBackground else {
            print("Não tem optionsBackground na OptionsMenu")
            return
        }
        
        let confirmLeaveBackground = SKShapeNode(rectOf: CGSize(width: optionsBackground.frame.width / 1.5, height: 300))
        confirmLeaveBackground.fillColor = .blue
        confirmLeaveBackground.position = .zero
        confirmLeaveBackground.zPosition = 20
        
        self.optionsBackground?.addChild(confirmLeaveBackground)
        
        let leaveLabel = SKLabelNode(text: "Tem certeza que deseja sair do jogo?")
        leaveLabel.fontName = "Lora-Medium"
        leaveLabel.position = .zero
        leaveLabel.position.y += 20
        leaveLabel.fontSize = 20
        confirmLeaveBackground.addChild(leaveLabel)
        
        let noOption = SKLabelNode(text: "Não")
        noOption.fontName = "Lora-Medium"
        noOption.position = .zero
        noOption.position.y -= 60
        noOption.position.x -= 60
        confirmLeaveBackground.addChild(noOption)
        
        let noArrow = SKSpriteNode(imageNamed: "seta2")
        let scale = 35 / noArrow.frame.height
        noArrow.setScale(scale)
        noArrow.position = noOption.position
        noArrow.position.x -= noOption.frame.width
        noArrow.position.y -= 10
        confirmLeaveBackground.addChild(noArrow)
        
        let yesOption = SKLabelNode(text: "Sim")
        yesOption.fontName = "Lora-Medium"
        yesOption.position = .zero
        yesOption.position.y -= 60
        yesOption.position.x += 60
        confirmLeaveBackground.addChild(yesOption)
        
        let yesArrow = SKSpriteNode(imageNamed: "seta2")
        yesArrow.setScale(scale)
        yesArrow.position = yesOption.position
        yesArrow.position.x -= yesOption.frame.width
        yesArrow.position.y += yesOption.frame.height / 6
        confirmLeaveBackground.addChild(yesArrow)
    }
    
    private func configurationsButtonPressed () {
        configurations = Configurations(self.pause)
        configurations?.setupConfigurations()
        pause.pauseState = .CONFIGURATIONS
    }
}
