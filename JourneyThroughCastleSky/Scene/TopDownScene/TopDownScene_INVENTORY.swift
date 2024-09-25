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
        let inventorySize = CGSize(width: size.width * 0.5, height: size.height * 0.5)
                
        // Cria o inventário como um SKShapeNode (um retângulo com bordas arredondadas)
        inventory = SKShapeNode(rectOf: inventorySize, cornerRadius: 20)
        guard let inventory else {return}
        
        // Configura a cor do inventário
        inventory.fillColor = .gray
        inventory.strokeColor = .white
        inventory.lineWidth = 5
        inventory.zPosition = 10
                
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
    }
    
    /// Função que adiciona os itens dentro do inventório.
    internal func addInventoryItems () {
        var reference = -100
        User.singleton.inventoryComponent.itens.forEach({ item in
            let node = item.spriteComponent.sprite
            node.scale(to: CGSize(width: 100, height: 100))
            node.position = .zero
            node.position.x += CGFloat(reference)
            reference += 100
            inventory?.addChild(node)
        })
    }
}
