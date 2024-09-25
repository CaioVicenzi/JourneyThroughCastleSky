//
//  ViewController.swift
//  JourneyThroughCastleSky
//
//  Created by Caio Marques on 11/09/24.
//

import Cocoa
import SpriteKit
import GameplayKit

class ViewController: NSViewController {

    @IBOutlet var skView: SKView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        if let view = self.skView {
            let gameScene =  GameScene(size: view.frame.size, enemies: [
                Enemy(x: 100, y: 100, damage: 10, health: 100, spriteName: "enemy"),
                Enemy(x: 600, y: 200, damage: 10, health: 100, spriteName: "monster"),
            ], itens: [
                Item(name: "Maçã de diamante", spriteName: "diamondApple", effect: Effect(type: .DAMAGE, amount: 50), x: 400, y: 200, description: "Maçã de diamante muito roubada, aumenta seu ataque em 50")
            ], friendlies: [
                Friendly(spriteName: "papyrus", xPosition: 900, yPosition: 100, dialogs: [Dialogue(text: "Olá, eu sou o Papyrus", person: "Papyrus", velocity: 20), Dialogue(text: "Eu sou seu amigo", person: "Papyrus", velocity: 20)])
            ], background: SKSpriteNode(imageNamed: "background"))//GameScene(size: view.frame.size, ene)
            gameScene.scaleMode = .aspectFill
            PositionHelper.singleton.config(gameScene)
            view.presentScene(gameScene)
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
}

