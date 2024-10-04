//
//  CutsceneSceneOne.swift
//  JourneyThroughCastleSky
//
//  Created by João Ângelo on 03/10/24.
//

import Foundation
import SpriteKit

class CutsceneSceneOne: SKScene{
    
    var background = SKSpriteNode(imageNamed: "bgimage")
    var timer: Timer?
    
    var count: Int = 0

    override func didMove(to view: SKView) {
        backgroundColor = .red
        background.position = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
        addChild(background)
        
        startTimer()
    }
    
    func startTimer(){
        timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(setTimer), userInfo: nil, repeats: true)
    }
    
    @objc func setTimer(){
        count += 1
        if count == 1{
            let newScene = CutsceneSceneTwo(size: self.size)
            let transition = SKTransition.fade(withDuration: 1.0)
            self.view?.presentScene(newScene, transition: transition)
        }
        else if count == 2{
            let newScene = CutsceneSceneThree(size: self.size)
            let transition = SKTransition.fade(withDuration: 1.0)
            self.view?.presentScene(newScene, transition: transition)
            timer?.invalidate()
        }
    }
}

class CutsceneSceneTwo: SKScene{
    
    var background = SKSpriteNode(imageNamed: "bgimage")

    override func didMove(to view: SKView) {
        backgroundColor = .brown
        background.position = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
        addChild(background)
    }
}

class CutsceneSceneThree: SKScene{
    
    var background = SKSpriteNode(imageNamed: "bgimage")

    override func didMove(to view: SKView) {
        backgroundColor = .yellow
        background.position = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
        addChild(background)
    }
}
