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
            let gameScene =  GameScene(size: view.frame.size, enemies: [], itens: [], friendlies: [], background: SKSpriteNode(imageNamed: "background"))//GameScene(size: view.frame.size, ene)
            gameScene.scaleMode = .aspectFill
            PositionHelper.singleton.config(gameScene)
            view.presentScene(gameScene)
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
}

