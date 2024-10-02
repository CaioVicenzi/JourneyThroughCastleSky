//
//  PauseMenu.swift
//  JourneyThroughCastleSky
//
//  Created by Caio Marques on 02/10/24.
//

import Foundation
import SpriteKit

class PauseMenu : UIComponent {
    var selectedOption : Int = 0
    var base : SKShapeNode? = nil
    let buttonAmount = 2
    
    func addToScene(_ scene: SKScene) {
        self.base = SKShapeNode(rectOf: CGSize(width: scene.size.width / 2, height: scene.size.height / 2))
        guard let base else {print("alguma coisa deu muito errada na addToScene"); return}
        base.position = .zero
        base.fillColor = .gray
        base.zPosition = 20
        base.name = "menuPause"
        
        let titlePause = SKLabelNode(text: "Pause")
        titlePause.position = .zero
        titlePause.position.y += 100
        titlePause.fontName = "Helvetica-Bold"
        
        base.addChild(titlePause)
        
        makeButton(base, label: "Voltar", distance: 0)
        makeButton(base, label: "Sair do jogo", distance: 100)
        updateButtonColors()
        
        if let scene = scene as? GameScene {
            scene.cameraNode.addChild(base)
        }
    }
    
    private func makeButton (_ base : SKShapeNode, label : String, distance : Int) {
        let option = SKShapeNode(rectOf: CGSize(width: 150, height: 50))
        let labelNode = SKLabelNode(text: label)
        labelNode.position = .zero
        labelNode.fontSize = 18
        option.position = .zero
        option.position.y -= CGFloat(distance)
        base.addChild(option)
        option.addChild(labelNode)
        option.name = "buttonOption"
    }
    
    /// Função que serve para tirar o menu pause da cena.
    func cleanMenuPause (cameraNode : SKCameraNode) {
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
    
    private func updateButtonColors () {
        var i = 0
        base?.enumerateChildNodes(withName: "buttonOption", using: {[weak self] node, _ in
            guard let node = node as? SKShapeNode else {return}
            
            if i == self?.selectedOption {
                node.fillColor = .blue
            } else {
                node.fillColor = .gray
            }
            i += 1
        })
    }
    
    func pressDownKey () {
        if selectedOption < buttonAmount - 1 {
            selectedOption += 1
            updateButtonColors()
        }
    }
    
    func pressUpKey () {
        if selectedOption > 0 {
            selectedOption -= 1
            updateButtonColors()
        }
        
    }
    
    func pressEnterKey() {
        if selectedOption == 0 {
            print("Opção 1 escolhida")
        } else {
            print("Opção 2 escolhida")
        }
    }
}
