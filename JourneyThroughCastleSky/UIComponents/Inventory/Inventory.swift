//
//  Inventory.swift
//  JourneyThroughCastleSky
//
//  Created by Caio Marques on 07/11/24.
//

import Foundation
import SpriteKit

class Inventory {
    var gameScene : TopDownScene
    var inventory : SKShapeNode?
    var topBarNode : SKSpriteNode?
    var optionSelected = 1
    var optionsOptionsSelected = 1
    var exitGameSelection = 1
    
    var titleSelectedItem : SKLabelNode?
    var descriptionSelectedItem : SKLabelNode?
    
    var inventoryState : InventoryState = .NORMAL
    
    var itemsBackground : SKShapeNode?
    var optionsBackground : SKShapeNode?
    var creditsBackground : SKShapeNode?
    
    enum InventoryState {
        case NORMAL, OPTIONS, CREDIT, ITEMS, CONFIRM_EXIT_GAME
    }
    
    init(gameScene: TopDownScene) {
        self.gameScene = gameScene
    }
    
    func setupInventory () {
        
        inventory = SKShapeNode(rectOf: self.gameScene.size)
        guard let backgroundInventory = inventory else {
            return
        }
        backgroundInventory.fillColor = .black.withAlphaComponent(0.90)
        backgroundInventory.position = .zero
        backgroundInventory.strokeColor = .clear
        backgroundInventory.zPosition = 5
        backgroundInventory.name = "inventory"
        
        gameScene.cameraNode.addChild(backgroundInventory)
        
        topBarNode = SKSpriteNode(imageNamed: "topMenu")
        guard let topBarNode else {
            return
        }
        topBarNode.position = .zero
        topBarNode.position.y += self.gameScene.size.height / 3
        topBarNode.setScale(0.6)
        topBarNode.zPosition = 6
        topBarNode.name = "topBarNode"
        backgroundInventory.addChild(topBarNode)
        setupTopButton("ITENS", topBarNode: topBarNode, number: 1)
        setupTopButton("OPÇÕES", topBarNode: topBarNode, number: 2)
        setupTopButton("CRÉDITOS", topBarNode: topBarNode, number: 3)
        
        setupItems()
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
    
    /// Função que adiciona os itens dentro do inventório.
    internal func addInventoryItems () {
        var reference = -100
        var referencey = 0.0
        var index = 0
        User.singleton.inventoryComponent.itens.forEach({ item in
            let squareBehind = SKShapeNode(rectOf: CGSize(width: 100, height: 100))
            squareBehind.position = .zero
            squareBehind.fillColor = .gray
            squareBehind.strokeColor = .white
            squareBehind.position.x += CGFloat(reference)
            squareBehind.name = "inventorySquare\(index)"
            
            squareBehind.position.y += referencey
            
            let node = item.spriteComponent.sprite
            squareBehind.addChild(node)
            node.scale(to: CGSize(width: 60, height: 60))
            node.position = .zero
            index += 1
            if index == 3 {
                referencey = -110
                reference = -100
            } else {
                reference += 110
            }
            
            inventory?.addChild(squareBehind)
        })
    }
    
    func setupDetailItem () {
        guard let inventory else {fatalError("Não existe um inventário")}
        
        let base = SKShapeNode(rectOf: CGSize(width: inventory.frame.width - 10, height: gameScene.size.height / 8))
        base.strokeColor = .white
        base.fillColor = .gray
        base.position.y = inventory.position.y - (inventory.frame.height / 3)
        
        inventory.addChild(base)
    }
    
    func input(_ keyCode : Int) {
        let isEnterKey = keyCode == 36
        let isEscKey = keyCode == 53
        let isLeftArrow = keyCode == 123
        let isRightArrow = keyCode == 124
        let isUpArrow = keyCode == 126
        let isDownArrow = keyCode == 125
        
        if self.inventoryState == .NORMAL {
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
                switch optionSelected {
                case 1: inventoryState = .ITEMS
                case 2: inventoryState = .OPTIONS
                case 3: inventoryState = .CREDIT
                default: inventoryState = .NORMAL
                }
            }
        }
        
        if self.inventoryState == .OPTIONS {
            if isUpArrow {
                if optionsOptionsSelected > 1 {
                    self.optionsOptionsSelected -= 1
                }
            }
            
            if isDownArrow {
                if optionsOptionsSelected < 3 {
                    self.optionsOptionsSelected += 1
                }
            }
            
            if isEscKey {
                self.inventoryState = .NORMAL
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
        
        if self.inventoryState == .CONFIRM_EXIT_GAME {
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
    
    func closeInventory () {
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
    
    private func setupItems () {
        itemsBackground = SKShapeNode(rectOf: CGSize(width: gameScene.size.width / 1.2, height: gameScene.size.height / 1.8))
        itemsBackground?.position = .zero
        itemsBackground?.fillColor = .clear
        itemsBackground?.strokeColor = .clear
        itemsBackground?.position.y -= 50
        if let itemsBackground {
            inventory?.addChild(itemsBackground)
        }
        
        setupBar("Vida")
        setupBar("Vigor")
        
        setupButton("Consumíveis")
        setupButton("Acervo")
        
        setupItemsInventory()
        
        itemsBackground?.isHidden = false
    }
    
    private func setupBar (_ content : String) {
        guard let itemsBackground else {return}
        let backgroundBar = SKSpriteNode(imageNamed: "\(content.lowercased())-tag")
        backgroundBar.position = .zero
        
        //let scale = 200 / backgroundBar.frame.width
        backgroundBar.setScale(0.65)
        backgroundBar.position.x -= itemsBackground.frame.width / 3
        backgroundBar.position.y = .zero
        backgroundBar.zPosition += 2
        
        if content == "Vida" {
            backgroundBar.position.y += itemsBackground.frame.height / 2.25
        } else if content == "Vigor" {
            backgroundBar.position.y += (((itemsBackground.frame.height / 2.25) - backgroundBar.frame.height) - 30)
        }
        
        
        let label = SKLabelNode(text: content)
        label.fontName = "Lora-Medium"
        label.position = .zero
        label.position.y += 10
        label.position.x -= backgroundBar.frame.width / 3
        label.fontColor = .black
        label.zPosition += 1
        backgroundBar.addChild(label)
        
        let size = CGSize(width: (backgroundBar.frame.width * 1.4), height: backgroundBar.frame.height / 1.55)
        let bar = SKSpriteNode(color: content == "Vida" ? .wine : .darkGold, size: size)
        bar.position = .zero
        bar.position.x -= bar.frame.width / 2
        bar.position.y -= backgroundBar.frame.height / 2.25
        bar.zPosition -= 1
        bar.anchorPoint = CGPoint(x: 0, y: 0.5)

        backgroundBar.addChild(bar)
        
        let lifePercentage : CGFloat = CGFloat(User.singleton.healthComponent.health) / CGFloat(User.singleton.healthComponent.maxHealth)
        bar.xScale = lifePercentage
        
        
        self.itemsBackground?.addChild(backgroundBar)
    }
    
    private func setupButton (_ content : String) {
        guard let itemsBackground else {return}
        let buttonSprite = SKSpriteNode(imageNamed: "buttonUnselected")
        buttonSprite.position = .zero
        buttonSprite.position.x -= itemsBackground.frame.width / 3
        let scale = 70 / buttonSprite.size.height
        buttonSprite.setScale(scale)
        
        if content == "Consumíveis" {
            buttonSprite.position.y -= itemsBackground.frame.height / 6
        }
        
        if content == "Acervo" {
            buttonSprite.position.y -= ((itemsBackground.frame.height / 6) + buttonSprite.frame.height + 30)
        }
        
        itemsBackground.addChild(buttonSprite)
        
        let label = SKLabelNode(text: content)
        label.fontName = "Lora-Medium"
        label.position = .zero
        label.fontColor = .black
        label.position.y -= buttonSprite.frame.height / 6
        label.zPosition += 1
        buttonSprite.addChild(label)
        label.fontSize = 28
        
    }
    
    private func setupItemsInventory () {
        guard let itemsBackground else {
            return
        }
        
        let itemsInventory = SKSpriteNode(imageNamed: "itemsInventory")
        itemsInventory.setScale(0.55)
        itemsInventory.position = .zero
        itemsInventory.position.x += itemsBackground.frame.width / 4
        self.itemsBackground?.addChild(itemsInventory)
    }
    
    private func setupCredits () {
        creditsBackground = SKShapeNode(rectOf: CGSize(width: gameScene.size.width / 1.2, height: gameScene.size.height / 1.8))
        creditsBackground?.position = .zero
        creditsBackground?.fillColor = .blue
        creditsBackground?.position.y -= 50
        if let creditsBackground {
            inventory?.addChild(creditsBackground)
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
        if self.inventoryState == .OPTIONS {
            updateOptions()
        }
    }
}
