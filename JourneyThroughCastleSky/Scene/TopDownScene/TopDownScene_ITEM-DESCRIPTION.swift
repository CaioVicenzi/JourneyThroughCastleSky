//
//  TopDownScene_ITEM-DESCRIPTION.swift
//  JourneyThroughCastleSky
//
//  Created by Caio Marques on 25/09/24.
//

import Foundation
import SpriteKit

/// Todas as funções relacionadas à descrição de um item que acontece quando o usuário adiciona um item dentro do seu inventário.
extension TopDownScene {
    
    /// Função que mostra a descrição de um item que ela recebe como argumento
    func showItemDescription (_ item : DescriptionToPass) {
        // adicionando um node que cobre toda a tela para deixar a tela atrás da descrição do item mais escura.
        self.viewItemDescription = SKShapeNode(rect: CGRect(origin: .zero, size: self.size))
        guard let viewItemDescription else {return}
        
        // faz o setup desse node.
        viewItemDescription.fillColor = .black.withAlphaComponent(0.6)
        viewItemDescription.strokeColor = .black.withAlphaComponent(0.6)
        viewItemDescription.name = "cover"
        viewItemDescription.zPosition = 9
        viewItemDescription.alpha = 0
        
        // Cria o efeito de fadeIn para poder adicionar ele dentro dos componentes do viewItemDescription.
        let fadeIn = SKAction.fadeIn(withDuration: 0.5)
        viewItemDescription.run(fadeIn)
        
        self.addChild(viewItemDescription)
        
        // seta o gameState para esperando diálogo
        gameState = .WAITING_DIALOG
        
        let textLabel = SKLabelNode(text: "")
        setupTextLabel(textLabel)
        
        // setup do sprite.
        let sprite = item.sprite.copy() as? SKSpriteNode
        if let sprite {
            sprite.name = "cover"
            sprite.zPosition = 10
            sprite.position = PositionHelper.singleton.centralizeQuarterDown(textLabel)
            sprite.position.y += 200
            sprite.scale(to: CGSize(width: 300, height: 300))
            viewItemDescription.addChild(sprite)
            dialogSystem.typeEffect(item.description, velocity: 20, label: textLabel)
        }
    }
    
    /// função que faz o setup da label do texto
    private func setupTextLabel (_ textLabel : SKLabelNode) {
        guard let viewItemDescription else {return}
        textLabel.position = PositionHelper.singleton.centralizeQuarterDown(textLabel)
        textLabel.position.y -= 50
        textLabel.fontSize = 12
        textLabel.horizontalAlignmentMode = .center
        textLabel.name = "cover"
        textLabel.zPosition = 10
        viewItemDescription.addChild(textLabel)
    }
    
    /// Função que elimina todos os componentes da descrição do item.
    func unshowItemDescription () {
        guard let viewItemDescription else {return}
        let fadeOut = SKAction.fadeOut(withDuration: 0.2)
        let removeNode = SKAction.removeFromParent()
        
        for child in viewItemDescription.children {
            child.run(SKAction.sequence([fadeOut, removeNode]))
        }
                
        viewItemDescription.run(SKAction.sequence([fadeOut, removeNode]))
        self.viewItemDescription = nil
    }
}