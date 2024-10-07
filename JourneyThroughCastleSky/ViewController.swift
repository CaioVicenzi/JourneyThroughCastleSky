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
            User.singleton.inventoryComponent.itens
                .append(
                    .init(
                        name: "TESTE",
                        spriteName: "balloons",
                        dialogs: [],
                        effect: .init(type: .CURE, amount: 1),
                        x: 0,
                        y: 0,
                        description: "ASDASD"
                    )
                )
            let gameScene = BatalhaScene(size: view.frame.size)
            gameScene.config(enemy: Enemy(x: 0, y: 0, damage: 10, health: 100, spriteName: "enemy"))
            gameScene.scaleMode = .aspectFit
            PositionHelper.singleton.config(gameScene)
            view.presentScene(gameScene)
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
}

