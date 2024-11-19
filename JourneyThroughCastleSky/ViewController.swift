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
            let gameScene = BatalhaScene(size: skView.frame.size)
            gameScene
                .config(
                    enemy: .init(x: 0, y: 0, damage: 100, health: 100, spriteName: "larva"),
                    reward: .init(spriteName: "balloon", x: 0, y: 0, description: "Meu pau")
                )
            gameScene.scaleMode = .aspectFill
            PositionHelper.singleton.config(gameScene)
            view.presentScene(gameScene)
            
        }
    }
}

