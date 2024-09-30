//
//  MainMenuScene.swift
//  JourneyThroughCastleSky
//
//  Created by Caio Marques on 25/09/24.
//

import Foundation
import SpriteKit

class MainMenuScene : SKScene {
    let titleLabel : SKLabelNode = SKLabelNode(text: "Jouney Through Castle Sky")
    var startGameButton : SKShapeNode? = nil
    
    override func didMove(to view: SKView) {
        titleLabel.position = PositionHelper.singleton.centralizeQuarterUp(titleLabel)
        titleLabel.position.x += titleLabel.frame.width / 2
        addChild(titleLabel)
        
        startGameButton = SKShapeNode(rect: CGRect(origin: PositionHelper.singleton.centralizeQuarterDown(SKNode()), size: CGSize(width: 200, height: 50)))
        
        if let startGameButton {
            startGameButton.position.x -= startGameButton.frame.width / 2
        }
        
        startGameButton?.name = "startGameButton"
        
        if let startGameButton {
            addChild(startGameButton)
        }
    }
    
    override func mouseDown(with event: NSEvent) {
        let location = event.location(in: self)
        let clickedNode = self.atPoint(location)
        
        if clickedNode.name == "startGameButton" {
            let gameScene =  GameScene(size: size, enemies: [
                Enemy(x: 200, y: 100, damage: 10, health: 100, spriteName: "enemy"),
                Enemy(x: 600, y: 400, damage: 10, health: 100, spriteName: "monster"),
            ], itens: [
                Item(name: "Maçã de diamante", spriteName: "diamondApple", effect: Effect(type: .DAMAGE, amount: 50), x: 400, y: 200, description: "Maçã de diamante muito roubada, aumenta seu ataque em 50"),
                Item(name: "Bolinho", spriteName: "cupcake", effect: Effect(type: .CURE, amount: 10), x: 1000, y: 10, description: "Um bolinho muito massa que cura 10 pontos da sua vida")
            ], friendlies: [
                Friendly(spriteName: "papyrus", xPosition: 900, yPosition: 100, dialogs: [Dialogue(text: "Olá, eu sou o Papyrus", person: "Papyrus", velocity: 20), Dialogue(text: "Eu sou seu amigo", person: "Papyrus", velocity: 20)])
            ], background: SKSpriteNode(imageNamed: "background"))
            
            let transition = SKTransition.fade(withDuration: 1.0)
            self.view?.presentScene(gameScene, transition: transition)
        }
    }
}
