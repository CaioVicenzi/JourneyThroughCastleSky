//
//  TopDownScene_INVENTORY.swift
//  JourneyThroughCastleSky
//
//  Created by Caio Marques on 25/09/24.
//

import Foundation
import SpriteKit

/// Toda a parte da UI relacionada ao inventório
extension TopDownScene {
    
    /// Função que vai fazer o setup do inventório dentro da cena.
    internal func setupInventory () {
        // Definir o tamanho do inventário (80% da largura e 80% da altura da tela)
        let inventorySize = CGSize(width: size.width * 0.5, height: size.height * 0.6)
                
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
        cameraNode.addChild(inventory)
        
        // LABEL DO INVENTÓRIO
        let inventoryLabel = SKLabelNode(text: "Inventário")
        inventoryLabel.position = .zero
        inventoryLabel.position.y += (inventory.frame.height / 2) - 70
        inventory.addChild(inventoryLabel)
        
                
        // Adiciona alguns itens ao inventário
        addInventoryItems()
        
        
        updateLabelUseItem()
    }
    
    func updateLabelUseItem () {
        if User.singleton.inventoryComponent.itens.count >= 1 {
            if User.singleton.inventoryComponent.itens[inventoryItemSelected].consumableComponent?.effect.type != .NONE {
                addLabelUseItem()
            } else {
                removeLabelUseItem()
            }
        } else {
            removeLabelUseItem()
        }
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
    
    internal func updateInventorySquares () {
        let itemAmount = User.singleton.inventoryComponent.itens.count
        
        for i in 0 ..< itemAmount {
            let filho = inventory?.childNode(withName: "inventorySquare\(i)") as? SKShapeNode
            filho?.fillColor = i == inventoryItemSelected ? .blue : .gray
        }
    }
    
    private func addLabelUseItem () {
        self.useItemLabel = SKLabelNode()
        useItemLabel?.text = "Press U to use a item"
        useItemLabel?.fontColor = .red
        useItemLabel?.fontName = "Helvetica-Bold"
        useItemLabel?.fontSize = 12
        useItemLabel?.position = CGPoint(x: -(self.size.width / 3.47), y: -(self.size.height / 3))
        useItemLabel?.zPosition = 3
        
        if let useItemLabel {
            if useItemLabel.parent == nil {
                cameraNode.addChild(useItemLabel)
            }
        }
    }
    
    internal func removeLabelUseItem () {
        if let useItemLabel {
            if useItemLabel.parent != nil {
                useItemLabel.removeFromParent()
            }
        }
    }
}
