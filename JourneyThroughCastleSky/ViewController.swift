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

