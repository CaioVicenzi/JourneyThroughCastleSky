//
//  MainMenuScene.swift
//  JourneyThroughCastleSky
//
//  Created by Caio Marques on 25/09/24.
//

import Foundation
import SpriteKit

class MainMenuScene : SKScene {
    let titleLabel : SKLabelNode = SKLabelNode(text: "Journey Through Castle Sky")
    var startGameButton : SKShapeNode? = nil
    
    let titleLabelTwo : SKLabelNode = SKLabelNode(text: "Configurations")
    var configurationsGameButton : SKShapeNode? = nil
    
    override func didMove(to view: SKView) {
        titleLabel.position = PositionHelper.singleton.centralizeQuarterUp(titleLabel)
        titleLabel.position.x += titleLabel.frame.width / 2
        addChild(titleLabel)
        
        startGameButton = SKShapeNode(rect: CGRect(origin: PositionHelper.singleton.centralizeQuarterDown(SKNode()), size: CGSize(width: 200, height: 50)))
        
        titleLabelTwo.position = PositionHelper.singleton.centralizeQuarterDown(titleLabelTwo)
        titleLabelTwo.position.x += titleLabelTwo.frame.width/2
        titleLabelTwo.position.y -= titleLabel.position.y
        addChild(titleLabelTwo)
        
        configurationsGameButton = SKShapeNode(rect: CGRect(origin: PositionHelper.singleton.centralizeQuarterDown(SKNode()), size: CGSize(width: 200, height: 50)))
        
        if let startGameButton {
            startGameButton.position.x -= startGameButton.frame.width / 2
        }
        
        startGameButton?.name = "startGameButton"
        
        configurationsGameButton?.name = "configurationsGameButton"
        
        if let startGameButton {
            addChild(startGameButton)
        }
        
        if let configurationsGameButton{
            addChild(configurationsGameButton)
        }
    }
    
    override func mouseDown(with event: NSEvent) {
        let location = event.location(in: self)
        let clickedNode = self.atPoint(location)
        
        if clickedNode.name == "startGameButton" {

            if let scene = SKScene(fileNamed: "MainHallScene") as? MainHallScene {
                scene.scaleMode = .aspectFill
                let transition = SKTransition.fade(withDuration: 1.0)
                self.view?.presentScene(scene, transition: transition)
            } else {
                print("Failed to load Cutscene.")
            }
        }
        else if clickedNode.name == "configurationsGameButton" {
            let configurationsScene = ConfigurationsScene(size: self.size)
            configurationsScene.scaleMode = .aspectFill
            let transition = SKTransition.fade(withDuration: 1.0)
            self.view?.presentScene(configurationsScene, transition: transition)
        }
    }
}
