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
    
    // SETAS QUE CONTROLAM A CAIXA QUE VERIFICA SE O USUÁRIO TEM CERTEZA QUE QUER SAIR.
    var exitYesArrow : SKSpriteNode? = nil
    var exitNoArrow : SKSpriteNode? = nil
    var exitOptionSelected : Int = 1
    var confirmLeaveBackground : SKSpriteNode?
    
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
        
        updateOptions(true)
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
        buttonText.fontSize = 24
        buttonText.fontColor = .black
        buttonText.position = .zero
        buttonText.position.y -= baseButton.frame.height / 7
        buttonText.zPosition = 7
        baseButton.addChild(buttonText)
    }
    
    func updateOptions (_ isCleaning : Bool = false) {
        guard let inventory = self.optionsBackground else {
            print("Não temos inventory no Inventory")
            return
        }
        
        for child in inventory.children {
            if let childName = child.name {
                if childName.starts(with: "optionButton") {
                    if childName == "optionButton\(self.optionsSelected)" {
                        let novoButton = SKSpriteNode(imageNamed: isCleaning ? "buttonUnselected" : "buttonSelected")
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
        let isEnterKey = keyCode == 36 || keyCode == 7
        let isEscKey = keyCode == 53 || keyCode == 6
        let isUpArrow = keyCode == 126
        let isDownArrow = keyCode == 125
        let isLeftArrow = keyCode == 123
        let isRightArrow = keyCode == 124
        
        if self.pause.pauseState == .CONFIRM_EXIT_GAME {
            if isRightArrow {
                if self.exitOptionSelected < 2 {
                    self.exitOptionSelected += 1
                    updateExitArrows()
                }
            }else if isLeftArrow {
                if self.exitOptionSelected > 1 {
                    self.exitOptionSelected -= 1
                    updateExitArrows()
                }
            } else if isEnterKey {
                if self.exitOptionSelected == 1 {
                    self.confirmLeaveBackground?.removeAllChildren()
                    self.confirmLeaveBackground?.removeFromParent()
                    pause.pauseState = .OPTIONS
                } else if exitOptionSelected == 2 {
                    exit(1)
                }
            }
            
            return
        }
        
        
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
            updateOptions(true)
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
        
        gameScene.goBackTitleScene()
       // self.gameScene.view?.presentScene(mainMenu, transition: transition)
    }
    
    private func exitGameButtonPressed () {
        self.pause.pauseState = .CONFIRM_EXIT_GAME
        
        confirmLeaveBackground = SKSpriteNode(imageNamed: "itensSession")
        guard let confirmLeaveBackground else { return }
        
        confirmLeaveBackground.zPosition = 20
        confirmLeaveBackground.position = .zero
        confirmLeaveBackground.setScale(0.5)
        
        self.optionsBackground?.addChild(confirmLeaveBackground)
        
        let leaveLabel = SKLabelNode(text: "Tem certeza que deseja sair do jogo?")
        leaveLabel.fontName = "Lora-Bold"
        leaveLabel.position = .zero
        leaveLabel.position.y += confirmLeaveBackground.frame.height / 2
        leaveLabel.position.y -= 70
        leaveLabel.fontColor = .black
        leaveLabel.fontSize = 48
        leaveLabel.preferredMaxLayoutWidth = confirmLeaveBackground.frame.width - 50
        leaveLabel.horizontalAlignmentMode = .center
        leaveLabel.numberOfLines = 2
        confirmLeaveBackground.addChild(leaveLabel)
        
        let noOption = SKLabelNode(text: "Não")
        noOption.fontName = "Lora-Medium"
        noOption.position = .zero
        noOption.position.y -= 60
        noOption.position.x -= 140
        noOption.fontSize = 48
        noOption.fontColor = .black
        confirmLeaveBackground.addChild(noOption)
        
        exitNoArrow = SKSpriteNode(imageNamed: "seta2")
        
        guard let exitNoArrow else {
            return
        }
        
        let scale = 40 / exitNoArrow.frame.height
        exitNoArrow.setScale(scale)
        exitNoArrow.position = noOption.position
        exitNoArrow.position.x -= noOption.frame.width
        exitNoArrow.position.y += noOption.frame.height / 4
        exitNoArrow.isHidden = true
        confirmLeaveBackground.addChild(exitNoArrow)
        
        let yesOption = SKLabelNode(text: "Sim")
        yesOption.fontName = "Lora-Medium"
        yesOption.fontColor = .black
        yesOption.position = .zero
        yesOption.position.y -= 60
        yesOption.position.x += 140
        yesOption.fontSize = 48
        
        confirmLeaveBackground.addChild(yesOption)
        
        exitYesArrow = SKSpriteNode(imageNamed: "seta2")
        guard let exitYesArrow else {
            return
        }
        
        exitYesArrow.setScale(scale)
        exitYesArrow.position = yesOption.position
        exitYesArrow.position.x -= yesOption.frame.width
        exitYesArrow.position.y += yesOption.frame.height / 4
        exitYesArrow.isHidden = true
        confirmLeaveBackground.addChild(exitYesArrow)
        
        updateExitArrows()
    }
    
    private func configurationsButtonPressed () {
        configurations = Configurations(self.pause)
        configurations?.setupConfigurations()
        pause.pauseState = .CONFIGURATIONS
    }
    
    private func updateExitArrows () {
        if self.exitOptionSelected == 1 {
            self.exitNoArrow?.isHidden = false
            self.exitYesArrow?.isHidden = true
        } else if self.exitOptionSelected == 2 {
            self.exitNoArrow?.isHidden = true
            self.exitYesArrow?.isHidden = false
        } else {
            print("ERRO: O EXITOPTIONSELECTED É \(exitOptionSelected)")
        }
    }
}
