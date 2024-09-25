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
    var coordinator : MainCoordinator
    
    init(coordinator : MainCoordinator) {
        self.coordinator = coordinator
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init?(coder) não está implementado")
    }
    
    
    override func didMove(to view: SKView) {
        titleLabel.position = PositionHelper.singleton.centralizeQuarterUp(titleLabel)
        addChild(titleLabel)
        
        startGameButton = SKShapeNode(rect: CGRect(origin: PositionHelper.singleton.centralizeQuarterDown(SKNode()), size: CGSize(width: 200, height: 50)))
        startGameButton?.name = "startGameButton"
        
        if let startGameButton {
            addChild(startGameButton)
        }
    }
    
    override func mouseDown(with event: NSEvent) {
        let location = event.location(in: self)
        let clickedNode = self.atPoint(location)
        
        
        if clickedNode.name == "startGameButton"{
            coordinator.navigate(to: .GameScene)
        }
    }
}
