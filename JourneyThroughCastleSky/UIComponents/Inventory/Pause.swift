//
//  Pause.swift
//  JourneyThroughCastleSky
//
//  Created by Caio Marques on 07/11/24.
//

import Foundation
import SpriteKit

class Pause {
    var gameScene : TopDownScene
    var pause : SKShapeNode?
    var topBarNode : SKSpriteNode?
    
    var optionSelected = 1
    var optionsOptionsSelected = 1
    var inventoryCategorySelected = 1
    var exitGameSelection = 1
    var inventoryItemSelected = 1
    
    var titleSelectedItem : SKLabelNode?
    var descriptionSelectedItem : SKLabelNode?
    
    var pauseState : InventoryState = .NORMAL
    
    var itemsBackground : SKShapeNode?
    var optionsBackground : SKShapeNode?
    var creditsBackground : SKShapeNode?
    
    enum InventoryState {
        case NORMAL, OPTIONS, CREDIT, ITEMS, CONFIRM_EXIT_GAME, ITEM_SELECTION
    }
    
    init(gameScene: TopDownScene) {
        self.gameScene = gameScene
    }
    
    func setupPause () {
        
        pause = SKShapeNode(rectOf: self.gameScene.size)
        guard let backgroundPause = pause else {
            return
        }
        backgroundPause.fillColor = .black.withAlphaComponent(0.90)
        backgroundPause.position = .zero
        backgroundPause.strokeColor = .clear
        backgroundPause.zPosition = 5
        backgroundPause.name = "inventory"
        
        gameScene.cameraNode.addChild(backgroundPause)
        
        topBarNode = SKSpriteNode(imageNamed: "topMenu")
        guard let topBarNode else {
            return
        }
        topBarNode.position = .zero
        topBarNode.position.y += self.gameScene.size.height / 3
        topBarNode.setScale(0.6)
        topBarNode.zPosition = 6
        topBarNode.name = "topBarNode"
        backgroundPause.addChild(topBarNode)
        setupTopButton("ITENS", topBarNode: topBarNode, number: 1)
        setupTopButton("OPÇÕES", topBarNode: topBarNode, number: 2)
        setupTopButton("CRÉDITOS", topBarNode: topBarNode, number: 3)
        
        setupInventory()
        setupCredits()
        setupOptions()
    }
    
    private func setupTopButton (_ label : String, topBarNode : SKNode, number : Int) {
        let xPosition : CGFloat
        
        if number == 1 {
            xPosition = -(self.gameScene.size.width / 2.5)
        } else if number == 2 {
            xPosition = .zero
        } else {
            xPosition = self.gameScene.size.width / 2.5
        }
         
        let itemsLabel = SKLabelNode(text: label)
        itemsLabel.fontName = "Lora-Medium"
        itemsLabel.fontSize = 40
        itemsLabel.position.y = .zero
        itemsLabel.position.y -= topBarNode.frame.height / 8
        itemsLabel.position.x = xPosition
        itemsLabel.fontColor = .black
        itemsLabel.zPosition = 7
        topBarNode.addChild(itemsLabel)
        
        
        let seta = SKSpriteNode(imageNamed: "seta2")
        let proportion = 40 / seta.frame.width
        seta.setScale(proportion)
        seta.position.y = .zero
        seta.position.y += topBarNode.frame.height / 9
        seta.position.x = xPosition - (itemsLabel.frame.width / 2) - 40
        seta.zPosition = 7
        seta.name = "seta\(number)"
        seta.isHidden = false
        topBarNode.addChild(seta)
        
    }
    
    
    
    func setupDetailItem () {
        guard let pause else {fatalError("Não existe um inventário")}
        
        let base = SKShapeNode(rectOf: CGSize(width: pause.frame.width - 10, height: gameScene.size.height / 8))
        base.strokeColor = .white
        base.fillColor = .gray
        base.position.y = pause.position.y - (pause.frame.height / 3)
        
        pause.addChild(base)
    }
    
    func input(_ keyCode : Int) {
        let isEnterKey = keyCode == 36
        let isEscKey = keyCode == 53
        let isLeftArrow = keyCode == 123
        let isRightArrow = keyCode == 124
        let isUpArrow = keyCode == 126
        let isDownArrow = keyCode == 125
        
        if self.pauseState == .NORMAL {
            if isLeftArrow {
                if optionSelected > 1 {
                    self.optionSelected -= 1
                }
                updateDownPart()
            }
            
            if isRightArrow {
                if optionSelected < 3 {
                    self.optionSelected += 1
                }
                updateDownPart()
            }
            
            if isEnterKey {
                let itemAmount = User.singleton.inventoryComponent.itens.count
                
                switch optionSelected {
                case 1: pauseState = itemAmount != 0 ? .ITEMS : .NORMAL
                case 2: pauseState = .OPTIONS
                case 3: pauseState = .CREDIT
                default: pauseState = .NORMAL
                }
            }
        }
        
        else if self.pauseState == .OPTIONS {
            if isUpArrow {
                if optionsOptionsSelected > 1 {
                    self.optionsOptionsSelected -= 1
                }
            }
            // MEET ME HALFWAY
            if isDownArrow {
                if optionsOptionsSelected < 3 {
                    self.optionsOptionsSelected += 1
                }
            }
            
            if isEscKey {
                self.pauseState = .NORMAL
            }
            
            if isEnterKey {
                switch optionsOptionsSelected {
                    case 1: titleScreenButtonPressed()
                    case 2: exitGameButtonPressed()
                    case 3: configurationsButtonPressed()
                    default: break
                }
            }
        }
        
        else if self.pauseState == .CONFIRM_EXIT_GAME {
            if isRightArrow {
                if exitGameSelection == 1 {
                    exitGameSelection += 1
                }
            } else if isLeftArrow {
                if exitGameSelection == 2 {
                    exitGameSelection -= 1
                }
            }
        }
        
        else if self.pauseState == .ITEMS {
            if isUpArrow {
                if inventoryCategorySelected == 2 {
                    self.inventoryCategorySelected -= 1
                    updateItemsThroughCategories()
                }
            }
            
            if isDownArrow {
                if inventoryCategorySelected == 1 {
                    self.inventoryCategorySelected += 1
                    updateItemsThroughCategories()
                }
            }
            
            if isEnterKey {
                self.pauseState = .ITEM_SELECTION
            }
            
            if isEscKey {
                pauseState = .NORMAL
                //limpar todos as as opções
                cleanItemCategoryButtons()
            }
        }
        
        else if self.pauseState == .ITEM_SELECTION {
            inputItems(keyCode)
        }
    }
    
    private func titleScreenButtonPressed() {
        // tem certeza que quer sair do jogo?
    }
    
    private func exitGameButtonPressed () {
        guard let optionsBackground else {
            print("oi")
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
        
    }
    
    
    func updateSelectedOptionArrow () {
        guard let topNode = topBarNode else {
            print("Não temos topNode no inventory.")
            return
        }
        for child in topNode.children {
            if let childName = child.name {
                if childName.starts(with: "seta") {
                    if childName == "seta\(optionSelected)" {
                        child.isHidden = false
                    } else {
                        child.isHidden = true
                    }
                }
            }
        }
    }
    
    private func updateExitGameSelection () {
        
    }
    
    func closePause () {
        gameScene.gameState = .NORMAL
        
        guard let inventory = gameScene.cameraNode.childNode(withName: "inventory") else {
            print("Nós não temos o inventory")
            return
        }
        
        inventory.children.forEach { node in
            node.removeFromParent()
        }
        inventory.removeFromParent()
    }
    
    private func cleanItemCategoryButtons () {
        self.inventoryCategorySelected = 1
        updateInventoryButtons(true)
    }
    
    private func setupCredits () {
        creditsBackground = SKShapeNode(rectOf: CGSize(width: gameScene.size.width / 1.2, height: gameScene.size.height / 1.8))
        creditsBackground?.position = .zero
        creditsBackground?.fillColor = .blue
        creditsBackground?.position.y -= 50
        if let creditsBackground {
            pause?.addChild(creditsBackground)
        }
        
        creditsBackground?.isHidden  = true
    }
    
    
    func updateDownPart () {
        switch self.optionSelected {
            case 1:
                showItems()
            case 2:
                showOptions()
            case 3:
                showCredits()
        default: showItems()
        }
    }
    
    func showCredits () {
        creditsBackground?.isHidden = false
        itemsBackground?.isHidden = true
        optionsBackground?.isHidden = true
    }
    
    func showItems () {
        creditsBackground?.isHidden = true
        itemsBackground?.isHidden = false
        optionsBackground?.isHidden = true
    }
    
    func showOptions () {
        creditsBackground?.isHidden = true
        itemsBackground?.isHidden = true
        optionsBackground?.isHidden = false
    }
    
    func update () {
        updateSelectedOptionArrow()
        if self.pauseState == .OPTIONS {
            updateOptions()
        }
        
        if pauseState == .ITEMS {
            updateInventoryButtons()
        }
        
        if pauseState == .ITEM_SELECTION {
            updateItemArrows ()
        }
    }
}
