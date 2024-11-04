//
//  ConfigurationsScene.swift
//  JourneyThroughCastleSky
//
//  Created by João Ângelo on 28/10/24.
//

import Foundation
import SpriteKit

class ConfigurationsScene: SKScene{
    
    override func didMove(to view: SKView) {
        setupNodes()
    }
    
    func setupNodes () {
        setupLabel()
        setupButtonBack()
    }
    
    func setupLabel() {
        let label = SKLabelNode(text: "Nós ainda não temos configurações...")
        label.position = PositionHelper.singleton.centralizeQuarterUp(SKLabelNode())
        label.fontSize = 20
        label.fontName = "Helvetica-Semibold"
        addChild(label)
    }
    
    func setupButtonBack () {
        let buttonBack = SKShapeNode(rectOf: CGSize(width: 200, height: 50))
        buttonBack.position = PositionHelper.singleton.centralize(SKShapeNode())
        buttonBack.fillColor = .red
        addChild(buttonBack)
        
        let buttonBackLabel = SKLabelNode()
        buttonBackLabel.text = "Voltar"
        buttonBackLabel.fontSize = 20
        buttonBackLabel.fontName = "Helvetica-Bold"
        buttonBackLabel.position = .zero
        buttonBackLabel.position.y -= buttonBackLabel.frame.height / 2
        buttonBack.addChild(buttonBackLabel)
    }
    
    override func keyDown(with event: NSEvent) {
        if event.keyCode == 36 {
            let mainScene = MainMenuScene(size: self.size)
            mainScene.scaleMode = .aspectFill
            self.view?.presentScene(mainScene, transition: SKTransition.fade(withDuration: 1.0))
        }
    }
    
    
    func setupOverallVolume(){
        
    }
    
    func setupEffectsVolume(){
        
    }
    
    func setupLanguage(){
        
    }
}
