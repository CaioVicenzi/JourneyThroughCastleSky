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
        
        let xPosition = -(size.width / 2)
        let yPosition = -(size.height / 2)
        let ponto = CGPoint(x: xPosition, y: yPosition)
        
        self.viewItemDescription = SKShapeNode(rect: CGRect(origin: ponto, size: self.size))
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
        
        cameraNode.addChild(viewItemDescription)
        
        // seta o gameState para esperando diálogo
        gameState = .WAITING_DIALOG
        
        let textLabel = SKLabelNode(text: "")
        setupTextLabel(textLabel)
        
        // setup do sprite.
        let sprite = item.sprite.copy() as? SKSpriteNode
        if let sprite {
            sprite.name = "cover"
            sprite.zPosition = 10
            sprite.position = .zero
            sprite.position.y += 100
            sprite.scale(to: CGSize(width: 300, height: 300))
            viewItemDescription.addChild(sprite)
            DialogSystem.typeEffect(item.description, velocity: 20, label: textLabel) {[weak self] in
                self?.gameState = .DIALOG_FINISHED
            }
        }
    }
    
    /// função que faz o setup da label do texto
    private func setupTextLabel (_ textLabel : SKLabelNode) {
        guard let viewItemDescription else {return}
        textLabel.position = .zero
        textLabel.position.y -= 100
        textLabel.position.y -= 50
        textLabel.fontSize = 12
        textLabel.horizontalAlignmentMode = .center
        textLabel.name = "cover"
        textLabel.zPosition = 10
        viewItemDescription.addChild(textLabel)
    }
    
    /// Função que elimina todos os componentes da descrição do item.
    func cleanItemDescription () {
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
