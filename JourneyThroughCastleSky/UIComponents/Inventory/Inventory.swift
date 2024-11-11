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
    //var inventoryItemSelected : Int = 0
    var optionSelected = 1
    var optionsOptionsSelected = 1
    
    var titleSelectedItem : SKLabelNode?
    var descriptionSelectedItem : SKLabelNode?
    
    var inventoryState : InventoryState = .NORMAL
    
    enum InventoryState {
        case NORMAL, OPTIONS, CREDIT, ITEMS
    }
    
    init(gameScene: TopDownScene) {
        self.gameScene = gameScene
    }
    
    func setupInventory () {
        
        inventory = SKShapeNode(rectOf: self.gameScene.size)
        guard let backgroundInventory = inventory else {
            return
        }
        backgroundInventory.fillColor = .black.withAlphaComponent(0.95)
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

        
        
        
        
        /*
        
        
        // Definir o tamanho do inventário (80% da largura e 80% da altura da tela)
        let inventorySize = CGSize(width: gameScene.size.width * 0.5, height: gameScene.size.height * 0.6)
                
        // Cria o inventário como um SKShapeNode (um retângulo com bordas arredondadas)
        inventory = SKShapeNode(rectOf: inventorySize, cornerRadius: 20)
        guard let inventory else {return}
        
        // Configura a cor do inventário
        inventory.fillColor = .gray
        inventory.strokeColor = .white
        inventory.lineWidth = 5
        inventory.zPosition = 15
                
        // Centraliza o inventário na tela
        inventory.position = .zero
        inventory.name = "inventory"
                
        // Adiciona o inventário à cena
        gameScene.cameraNode.addChild(inventory)
        
        // LABEL DO INVENTÓRIO
        let inventoryLabel = SKLabelNode(text: "Inventário")
        inventoryLabel.position = .zero
        inventoryLabel.position.y += (inventory.frame.height / 2) - 70
        inventory.addChild(inventoryLabel)
        
                
        // Adiciona alguns itens ao inventário
        addInventoryItems()
        
        setupDetailItem()
         */
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
        
        //setupSelectedItemLabels(base)
    }
    /*
    func setupSelectedItemLabels (_ base : SKShapeNode) {
        
        let item = InventorySystem.getInventoryItem(inventoryItemSelected)

        titleSelectedItem = SKLabelNode(text: item?.consumableComponent?.nome)
        descriptionSelectedItem = SKLabelNode(text: item?.readableComponent.readableDescription)
        
        titleSelectedItem?.fontSize = 20
        titleSelectedItem?.position = .zero
        
        descriptionSelectedItem?.fontSize = 14
        descriptionSelectedItem?.position = .zero
        descriptionSelectedItem?.position.y -= 40
        
        
        // é certeza que eles existe, afinal de contas, se a execução do código foi parar aqui, quer dizer que deu certo...
        base.addChild(titleSelectedItem!)
        base.addChild(descriptionSelectedItem!)
        
        
    }
     */
    
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
        }
        
        
        
        //selectItemInventory(keyCode)
        if isEnterKey {
            switch optionSelected {
            case 1: inventoryState = .ITEMS
            case 2: inventoryState = .OPTIONS
            case 3: inventoryState = .CREDIT
            default: inventoryState = .NORMAL
            }
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
    /*
    func updateSelectedItemLabels () {
        /*
        guard let titleSelectedItem, let descriptionSelectedItem else {
            return
        }
        
        let item = InventorySystem.getInventoryItem(inventoryItemSelected)
        titleSelectedItem.text = item?.consumableComponent?.nome
        descriptionSelectedItem.text = item?.readableComponent.readableDescription
         */
    }
    
    func updateInventorySquares () {
        /*
        let itemAmount = User.singleton.inventoryComponent.itens.count
        
        for i in 0 ..< itemAmount {
            let filho = inventory?.childNode(withName: "inventorySquare\(i)") as? SKShapeNode
            filho?.fillColor = i == inventoryItemSelected ? .blue : .gray
        }
         */
    }
     */
    
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
        
    }
    
    private func setupOptions () {
        setupLittleButton ("TELA DE TÍTULO", number: 1)
        setupLittleButton ("SAIR DO JOGO", number: 2)
        setupLittleButton ("CONFIGURAÇÕES", number: 3)
        
        
        func setupLittleButton (_ title : String, number : Int) {
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
            if let inventoryBackground = gameScene.cameraNode.childNode(withName: "inventory") {
                inventoryBackground.addChild(baseButton)
            }
            
            let buttonText = SKLabelNode(text: title)
            buttonText.fontName = "Lora-Medium"
            buttonText.fontSize = 32
            buttonText.fontColor = .black
            buttonText.position = .zero
            buttonText.position.y -= baseButton.frame.height / 5
            buttonText.zPosition = 7
            baseButton.addChild(buttonText)
            
            
        }
    }
    
    
    
    private func setupCredits () {
        
    }
    
    
    func updateDownPart () {
        switch self.optionSelected {
            case 1: setupItems()
            case 2: setupOptions()
            case 3: setupCredits()
            default: setupItems()
        }
    }
    
    func updateOptions () {
        guard let inventory = inventory else {
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
    
    func update () {
        updateSelectedOptionArrow()
        if self.inventoryState == .OPTIONS {
            updateOptions()
        }
    }
}
