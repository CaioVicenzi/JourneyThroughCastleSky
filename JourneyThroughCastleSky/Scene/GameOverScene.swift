//
//  GameOverScene.swift
//  JourneyThroughCastleSky
//
//  Created by Caio Marques on 11/09/24.
//

import Foundation
import SpriteKit

class GameOverScene : SKScene {
    private let gameOverLabel : SKLabelNode = SKLabelNode(text: "Fim de Jogo!")
    private var goBackButton : SKShapeNode?
    
    override func didMove(to view: SKView) {
        config()
        setupView()
    }
    
    override func update(_ currentTime: TimeInterval) {
        
    }
    
    private func setupView () {
        setupGameOverLabel()
        setupGoBackButton()
    }
    
    private func config () {
        backgroundColor = .black
    }
    
    // MARK: SETUP VIEW
    private func setupGameOverLabel () {
        gameOverLabel.position = PositionHelper.singleton.centralizeQuarterUp(gameOverLabel)
        addChild(gameOverLabel)
    }
    
    private func setupGoBackButton () {
        let sizeButton = CGSize(width: 300, height: 50)
        
        
        goBackButton = SKShapeNode(rect: CGRect(origin: CGPoint(), size: sizeButton), cornerRadius: 10)
        goBackButton?.position = PositionHelper.singleton.centralizeQuarterDown(goBackButton!)
        
        goBackButton?.fillColor = .brown
        goBackButton?.name = "goBackButton"
        
        // CRIANDO O TEXTO PARA ADICIONAR
        let textBackButton = SKLabelNode(text: "Jogar novamente")
        textBackButton.position = CGPoint(x: (goBackButton!.frame.size.width / 2), y: goBackButton!.frame.size.height / 4)
        textBackButton.zPosition = 1
        textBackButton.name = "textBackButton"
        
        goBackButton?.addChild(textBackButton)
        
        if let goBackButton {
            addChild(goBackButton)
        }
    }
    
    override func mouseDown(with event: NSEvent) {
        let location = event.location(in: self)
        let clickedNode = self.atPoint(location)
        if clickedNode.name == "goBackButton" || clickedNode.name == "textBackButton" {
            self.view?.presentScene(GameScene(size: self.size), transition: .fade(withDuration: 1))
        }
    }
    
}

