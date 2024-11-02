//
//  MainMenuScene.swift
//  JourneyThroughCastleSky
//
//  Created by Caio Marques on 25/09/24.
//

import Foundation
import SpriteKit
import SwiftUI

class MainMenuScene : SKScene {
    @AppStorage("estage") var estage : Int = 0
    var selectedButton : Int = 0
    let warning = WarningNewGame()
    
    override func didMove(to view: SKView) {
        warning.config(self)

        setupNodes()
    }
    
    override func update(_ currentTime: TimeInterval) {
        updateButtonColors()
    }
    
    private func setupNodes () {
        setupTitleLabel()
        setupButton("Novo Jogo", nodeName: "button0", yPosition: 0)
        setupButton("Carregar jogo", nodeName: "button1", yPosition: 75)
        setupButton("Configurations", nodeName: "button2", yPosition: 150)
    }
    
    private func setupTitleLabel () {
        let titleLabel = SKLabelNode()
        titleLabel.text = "Memorance"
        titleLabel.fontSize = 32
        titleLabel.fontName = "Helvetica-Bold"
        titleLabel.position = PositionHelper.singleton.centralizeQuarterUp(titleLabel)
        titleLabel.position.y += 50
        titleLabel.position.x += titleLabel.frame.width / 2
        addChild(titleLabel)
    }
    
    private func setupButton (_ text : String, nodeName : String, yPosition : CGFloat) {
        let newGameButton = SKShapeNode(rectOf: CGSize(width: 200, height: 50))
        newGameButton.fillColor = .lightGray
        newGameButton.strokeColor = .black
        newGameButton.position = PositionHelper.singleton.centralize(SKLabelNode())
        newGameButton.position.y -= yPosition
        newGameButton.name = nodeName
        
        let newGameButtonLabel = SKLabelNode(text: text)
        newGameButtonLabel.position = .zero
        newGameButtonLabel.fontSize = 20
        newGameButtonLabel.fontName = "Helvetica-Bold"
        newGameButtonLabel.position.y -= newGameButtonLabel.frame.height / 2
        newGameButton.addChild(newGameButtonLabel)
        
        
        addChild(newGameButton)
    }
    
    
    override func keyDown(with event: NSEvent) {
        if event.keyCode == 0x7E { // seta para cima
            if selectedButton > 0 {
                self.selectedButton -= 1
            }
        }
        
        if event.keyCode == 0x7D { // seta para baixo
            if selectedButton < 2 {
                self.selectedButton += 1
            }
        }
        
        if event.keyCode == 0x7B {// esquerda
            self.warning.down()
            warning.updateButtonColors()
        }
        
        if event.keyCode == 0x7C { // direita
            self.warning.up()
            warning.updateButtonColors()
        }
        
        if event.keyCode == 36 {
            enterPressed()
        }
    }
    
    func enterPressed () {
        switch selectedButton {
        case 0: newGame()
        case 1: goMainHallScene()
        case 2: goConfiguration()
        default: print("Enter inválido, porque o selected button é \(selectedButton)")
        }
    }
    
    private func newGame () {
        warning.warning()
        //estage = 0
        //goMainHallScene()
    }
    
    private func goConfiguration () {
        let configurationsScene = ConfigurationsScene(size: self.size)
        configurationsScene.scaleMode = .aspectFill
        let transition = SKTransition.fade(withDuration: 1.0)
        self.view?.presentScene(configurationsScene, transition: transition)
    }
    
    private func goMainHallScene () {
        if let scene = SKScene(fileNamed: "MainHallScene") as? MainHallScene {
            scene.scaleMode = .aspectFill
            let transition = SKTransition.fade(withDuration: 1.0)
            self.view?.presentScene(scene, transition: transition)
        } else {
            print("Failed to load Cutscene.")
        }
    }
    
    private func updateButtonColors () {
        for i in 0 ..< 3 {
            let child = childNode(withName: "button\(i)") as? SKShapeNode
            child?.fillColor = .lightGray
        }
        
        let button = childNode(withName: "button\(selectedButton)") as? SKShapeNode
        button?.fillColor = .red
    }
}
