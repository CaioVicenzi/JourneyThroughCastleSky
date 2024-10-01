//
//  TopDownScene_PAUSE.swift
//  JourneyThroughCastleSky
//
//  Created by Caio Marques on 01/10/24.
//

import Foundation
import SpriteKit

extension TopDownScene {
    internal func setupMenuPause () {
        let base = SKShapeNode(rectOf: CGSize(width: size.width / 2, height: size.height / 2))
        base.position = .zero
        base.fillColor = .gray
        base.zPosition = 20
        base.name = "menuPause"
        
        let titlePause = SKLabelNode(text: "Pause")
        titlePause.position = .zero
        titlePause.position.y += 100
        titlePause.fontName = "Helvetica-Bold"
        
        base.addChild(titlePause)
        
        let backOption = SKShapeNode(rectOf: CGSize(width: 150, height: 50))
        let backLabel = SKLabelNode(text: "Voltar")
        backLabel.position = .zero
        backLabel.fontSize = 18
        backOption.position = .zero
        backOption.fillColor = .blue
        base.addChild(backOption)
        backOption.addChild(backLabel)
        
        let exitOption = SKShapeNode(rectOf: CGSize(width: 150, height: 50))
        let exitLabel = SKLabelNode(text: "Sair do jogo")
        exitLabel.position = .zero
        exitLabel.fontSize = 18
        exitOption.position = .zero
        exitOption.position.y -= 100
        exitOption.fillColor = .brown
        base.addChild(exitOption)
        exitOption.addChild(exitLabel)
        
        cameraNode.addChild(base)
    }
    
    /// Função que serve para tirar o menu pause da cena.
    internal func cleanMenuPause () {
        let base = cameraNode.childNode(withName: "menuPause") as? SKShapeNode
        
        if let base {
            let filhos = base.children
            
            for filho in filhos {
                if filho.parent != nil {
                    filho.removeFromParent()
                }
            }
            
            if base.parent != nil {
                base.removeFromParent()
            }
        }
        
    }
}
