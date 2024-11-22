//
//  Inventory.swift
//  JourneyThroughCastleSky
//
//  Created by Caio Marques on 13/11/24.
//

import Foundation
import SpriteKit

class Inventory {
    // VARIÁVEIS QUE VÃO SER RECEBIDAS COMO ARGUMENTO NO CONSTRUTOR
    var pause : Pause
    var itemsBackground : SKShapeNode?
    var gameScene : TopDownScene
    
    // VARIÁVEIS DE SELEÇÃO DE INPUT
    var inventoryItemSelected : Int = 1
    var inventoryCategorySelected : Int = 1
    
    init(_ pause: Pause) {
        self.pause = pause
        self.gameScene = pause.gameScene
    }
    
    func setupInventory () {
        itemsBackground = SKShapeNode(rectOf: CGSize(width: gameScene.size.width / 1.2, height: gameScene.size.height / 1.8))
        itemsBackground?.position = .zero
        itemsBackground?.fillColor = .clear
        itemsBackground?.strokeColor = .clear
        itemsBackground?.position.y -= 50
        if let itemsBackground {
            pause.pauseBackground?.addChild(itemsBackground)
        }
        
        setupBar("VIDA")
        setupBar("VIGOR")
        
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
        
        if content == "VIDA" {
            backgroundBar.position.y += itemsBackground.frame.height / 2.25
        } else if content == "VIGOR" {
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
        let bar = SKSpriteNode(color: content == "VIDA" ? .wine : .darkGold, size: size)
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
            buttonSprite.name = "button1"
        }
        
        if content == "Acervo" {
            buttonSprite.position.y -= ((itemsBackground.frame.height / 6) + buttonSprite.frame.height + 30)
            buttonSprite.name = "button2"
        }
        
        itemsBackground.addChild(buttonSprite)
        
        let label = SKLabelNode(text: content)
        label.fontName = "Lora-Medium"
        label.position = .zero
        label.fontColor = .black
        label.position.y -= buttonSprite.frame.height / 5
        label.zPosition += 1
        buttonSprite.addChild(label)
        label.fontSize = 48
        
    }
    
    private func setupItemsInventory () {
        guard let itemsBackground else {
            return
        }
        
        let itemsInventory = SKSpriteNode(imageNamed: "itemsInventory")
        itemsInventory.setScale(0.55)
        itemsInventory.position = .zero
        itemsInventory.position.x += itemsBackground.frame.width / 4
        itemsInventory.name = "itemsBackground"
        addInventoryItems(itemsInventory, categoryItem: .CONSUMIVEIS)
        
        self.itemsBackground?.addChild(itemsInventory)
    }
    
    func inputCategoryItemSelection(_ keyCode : Int) {
        let isEnterKey = keyCode == 36
        let isEscKey = keyCode == 53
        let isUpArrow = keyCode == 126
        let isDownArrow = keyCode == 125
        
        if isUpArrow {
            if inventoryCategorySelected == 2 {
                inventoryCategorySelected -= 1
                updateItemsThroughCategories()
            }
        }
        
        if isDownArrow {
            if inventoryCategorySelected == 1 {
                inventoryCategorySelected += 1
                updateItemsThroughCategories()
            }
        }
        
        if isEnterKey {
            if (inventoryCategorySelected == 1 && consumableExists()) || (inventoryItemSelected == 2 && acervoExists()) {
                pause.pauseState = .ITEM_SELECTION
            }
        }
        
        if isEscKey {
            pause.pauseState = .NORMAL
            //limpar todos as as opções
            cleanItemCategoryButtons()
        }
    }
    
    private func cleanItemCategoryButtons () {
        self.inventoryCategorySelected = 1
        updateInventoryButtons(true)
    }
    
    // verifica se existe um item no acervo do usuário, retorna true se existe e false se não existe.
    private func acervoExists () -> Bool {
        for item in User.singleton.inventoryComponent.itens {
            if item.consumableComponent?.effect.type == .NONE {
                return true
            }
        }
        
        return false
    }
    
    // verifica se existe um item consumível dentro do inventário do usuário
    private func consumableExists () -> Bool {
        for item in User.singleton.inventoryComponent.itens {
            if item.consumableComponent?.effect.type != .NONE {
                return true
            }
        }
        
        return false
    }
    
    
    func inputItemSelection (_ keyCode : Int) {
        let isEnterKey = keyCode == 36
        let isEscKey = keyCode == 53
        let isLeftArrow = keyCode == 123
        let isRightArrow = keyCode == 124
        let isUpArrow = keyCode == 126
        let isDownArrow = keyCode == 125
    
        let itemAmount = User.singleton.inventoryComponent.itens.count
        
        if isLeftArrow {
            if inventoryItemSelected > 1 {
                inventoryItemSelected -= 1
            }
        }
        
        if isRightArrow {
            if inventoryItemSelected < itemAmount {
                inventoryItemSelected += 1
            }
        }
        
        if isUpArrow {
            if inventoryItemSelected - 4 > 0 {
                inventoryItemSelected -= 4
            }
         }
        
        if isDownArrow {
            if inventoryItemSelected + 4 < itemAmount - 1 {
                inventoryItemSelected += 4
            }
        }
        
        if isEnterKey {
            gameScene.inventorySystem.useItemFromInventory(in: inventoryItemSelected - 1)
        }
        
        if isEscKey {
            pause.pauseState = .ITEMS
            cleanItemsArrows()
        }
    }
    
    private func updateItemsThroughCategories () {
        cleanItems()
        
        if let itemsBackground = self.itemsBackground?.childNode(withName: "itemsBackground") as? SKSpriteNode {
            
            if inventoryCategorySelected == 1 {
                addInventoryItems(itemsBackground, categoryItem: .CONSUMIVEIS)
            } else {
                addInventoryItems(itemsBackground, categoryItem: .ACERVO)
            }
        }
    }
    
    enum CategoryItem {
        case CONSUMIVEIS
        case ACERVO
    }
    
    
    /// Função que adiciona os itens dentro do inventório.
    internal func addInventoryItems (_ inventorySprite : SKSpriteNode, categoryItem : CategoryItem) {
        var referencex = -(inventorySprite.frame.width / 2)
        var referencey = (inventorySprite.frame.height / 2)
        var index = 0
        User.singleton.inventoryComponent.itens.forEach({ item in
            if categoryItem == .ACERVO {
                if item.consumableComponent?.effect.type != .NONE {
                    return
                }
            }
            
            if categoryItem == .CONSUMIVEIS {
                if item.consumableComponent?.effect.type == .NONE {
                    return
                }
            }
            
            let node = item.spriteComponent.sprite
            //let scale = 30 / node.frame.width
            node.scale(to: CGSize(width: 100, height: node.frame.height * (100 / node.frame.height)))
            node.position = .zero
            node.position.y += referencey
            node.position.x += referencex
            node.zPosition += 3
            
            index += 1
            if index == 4 {
                referencey = -60
                referencex = -60
            } else {
                referencex += inventorySprite.frame.width / 2.5
            }
            
            let label = SKLabelNode(text: item.consumableComponent?.nome)
            label.preferredMaxLayoutWidth = 100
            label.position = node.position
            label.position.y -= node.frame.height / 1.5
            label.fontSize = 10
            label.fontName = "Lora-Medium"
            label.zPosition = node.zPosition
            inventorySprite.addChild(label)
            
            let arrow = SKSpriteNode(imageNamed: "seta2")
            arrow.position = node.position
            arrow.position.x -= node.frame.width / 1.25
            let arrowScale = 50 / arrow.frame.width
            arrow.setScale(arrowScale)
            inventorySprite.addChild(arrow)
            arrow.zPosition = node.zPosition
            arrow.name = "arrow\(index)"
            arrow.isHidden = true
            
            inventorySprite.addChild(node)
        })
    }
    
    private func cleanItemsArrows() {
        for i in 1 ..< User.singleton.inventoryComponent.itens.count + 1 {
            if let child = self.itemsBackground?.childNode(withName: "itemsBackground")?.childNode(withName: "arrow\(i)") as? SKSpriteNode {
                child.isHidden = true
            }
        }
    }
    
    private func cleanItems () {
        for _ in 1 ..< User.singleton.inventoryComponent.itens.count + 1 {
            if let itemsBackground = self.itemsBackground?.childNode(withName: "itemsBackground") {
                for child in itemsBackground.children {
                    child.removeFromParent()
                }
            }
        }
    }
    
    func updateInventoryButtons (_ isCleaning : Bool = false) {
        for i in 1 ..< 3 {

            if let child = self.itemsBackground?.childNode(withName: "button\(i)") as? SKSpriteNode {
                let individualRow : SKSpriteNode
                
                if i == inventoryCategorySelected && isCleaning == false {
                    individualRow = SKSpriteNode(imageNamed: "buttonSelected")
                } else {
                    individualRow = SKSpriteNode(imageNamed: "buttonUnselected")
                }
                
                individualRow.scale(to: CGSize(width: child.frame.width, height: child.frame.height))
                itemsBackground?.addChild(individualRow)
                individualRow.position = child.position
                individualRow.name = child.name
                
                for childChildren in child.children {
                    childChildren.removeFromParent()
                    individualRow.addChild(childChildren)
                }
                
                child.removeFromParent()
            }
        }
        
    }
    
    func updateItemArrows () {
        if User.singleton.inventoryComponent.itens.isEmpty {
            return
        }
        
        for i in 1 ..< User.singleton.inventoryComponent.itens.count + 1 {
            if let child = self.itemsBackground?.childNode(withName: "itemsBackground")?.childNode(withName: "arrow\(i)") as? SKSpriteNode {
                if i == self.inventoryItemSelected {
                    child.isHidden = false
                } else {
                    child.isHidden = true
                }
            }
        }
    }
    
    

}
