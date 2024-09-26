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
            gameScene.scaleMode = .aspectFill
            PositionHelper.singleton.config(gameScene)
            view.presentScene(gameScene)
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
}

