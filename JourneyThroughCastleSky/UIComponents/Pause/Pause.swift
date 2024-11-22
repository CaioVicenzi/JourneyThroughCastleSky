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
    var pauseBackground : SKShapeNode?
    var topBarNode : SKSpriteNode?
    
    var optionSelected = 1
    
    var titleSelectedItem : SKLabelNode?
    var descriptionSelectedItem : SKLabelNode?
    
    var pauseState : InventoryState = .NORMAL
    
    // MARK: OUTRAS VIEWS RELACIONADAS AO PAUSE
    var optionsMenu : OptionsMenu?
    var inventory : Inventory?
    var credits : Credits?
    
    enum InventoryState {
        case NORMAL, OPTIONS, ITEMS, CONFIRM_EXIT_GAME, ITEM_SELECTION, CONFIGURATIONS
    }
    
    init(gameScene: TopDownScene) {
        self.gameScene = gameScene
    }
    
    func setupPause () {
        
        pauseBackground = SKShapeNode(rectOf: self.gameScene.size)
        guard let backgroundPause = pauseBackground else {
            return
        }
        backgroundPause.fillColor = .black.withAlphaComponent(0.70)
        backgroundPause.position = .zero
        backgroundPause.strokeColor = .clear
        backgroundPause.zPosition = 100
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
        
        
        // fazendo o setup de todos os elementos
        inventory = Inventory(self)
        inventory?.setupInventory()

        credits = Credits(self)
        credits?.setupCredits()
        
        optionsMenu = OptionsMenu(self)
        optionsMenu?.setupOptions()
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
        itemsLabel.position.y -= topBarNode.frame.height / 7
        itemsLabel.position.x = xPosition
        itemsLabel.fontColor = .black
        itemsLabel.zPosition = 7
        topBarNode.addChild(itemsLabel)
        
        
        let seta = SKSpriteNode(imageNamed: "seta2")
        let proportion = 40 / seta.frame.width
        seta.setScale(proportion)
        seta.position.y = .zero
        seta.position.y += seta.frame.height / 9
        seta.position.x = xPosition - (itemsLabel.frame.width / 2) - 40
        seta.zPosition = 7
        seta.name = "seta\(number)"
        seta.isHidden = false
        topBarNode.addChild(seta)
        
    }
    
    
    
    func setupDetailItem () {
        guard let pauseBackground else {fatalError("Não existe um inventário")}
        
        let base = SKShapeNode(rectOf: CGSize(width: pauseBackground.frame.width - 10, height: gameScene.size.height / 8))
        base.strokeColor = .white
        base.fillColor = .gray
        base.position.y = pauseBackground.position.y - (pauseBackground.frame.height / 3)
        
        pauseBackground.addChild(base)
    }
    
    func input(_ keyCode : Int) {
        let isEnterKey = keyCode == 36
        let isLeftArrow = keyCode == 123
        let isRightArrow = keyCode == 124
        
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
                default: pauseState = .NORMAL
                }
            }
        }
        
        else if self.pauseState == .OPTIONS || self.pauseState == .CONFIRM_EXIT_GAME {
            self.optionsMenu?.input(keyCode)
        }
        
        else if self.pauseState == .ITEMS {
            inventory?.inputCategoryItemSelection(keyCode)
        }
        
        else if self.pauseState == .ITEM_SELECTION {
            inventory?.inputItemSelection(keyCode)
        }
        else if self.pauseState == .CONFIGURATIONS {
            optionsMenu?.configurations?.input(keyCode)
        }
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
        self.inventory?.itemsBackground?.isHidden = true
        self.optionsMenu?.optionsBackground?.isHidden = true
        self.credits?.creditsBackground?.isHidden = false
    }
    
    func showItems () {
        self.inventory?.itemsBackground?.isHidden = false
        self.optionsMenu?.optionsBackground?.isHidden = true
        self.credits?.creditsBackground?.isHidden = true
    }
    
    func showOptions () {
        self.inventory?.itemsBackground?.isHidden = true
        self.optionsMenu?.optionsBackground?.isHidden = false
        self.credits?.creditsBackground?.isHidden = true
    }
    
    func update () {
        updateSelectedOptionArrow()
        if self.pauseState == .OPTIONS {
            self.optionsMenu?.updateOptions()
        }
        
        if pauseState == .ITEMS {
            inventory?.updateInventoryButtons()
        }
        
        if pauseState == .ITEM_SELECTION {
            inventory?.updateItemArrows()
        }
    }
    
    func cleanInput () {
        self.optionSelected = 1
        self.pauseState = .NORMAL

        self.inventory?.inventoryItemSelected = 1
        self.optionsMenu?.optionsSelected = 1
        self.inventory?.inventoryCategorySelected = 1
    }
}
