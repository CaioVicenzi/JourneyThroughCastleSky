//
//  MainMenuScene.swift
//  JourneyThroughCastleSky
//
//  Created by Caio Marques on 25/09/24.
//

import Foundation
import SpriteKit

class MainMenuScene : SKScene {
    var selectedButton : Int = 0
    let warning = WarningNewGame()
    var menuState : MenuState = .CHOOSE_OPTION
    
    // uma enum que representa o estado do menu, eu coloquei somente dois, o primeiro é o que você escolhe a opção do menu e a CONFIRM_RESET é quando aparece o popup para você confirmar sua decisão de resetar o jogo.
    enum MenuState {
        case CHOOSE_OPTION
        case CONFIRM_RESET
    }
    
    override func didMove(to view: SKView) {
        warning.config(self)
        setupNodes()
    }
    
    private func setupNodes () {
        setupTitleLabel()
        setupButton("Novo Jogo", yPosition: 50, number: 0)
        setupButton("Carregar jogo", yPosition: 90, number: 1)
//        setupButton("Configurações", yPosition: 130, number: 2)
    }
    
    private func setupTitleLabel () {
        let mainMenuBackground = SKSpriteNode(imageNamed: "cutscene1_2")
        mainMenuBackground.position = PositionHelper.singleton.centralize(SKNode())
        mainMenuBackground.zPosition = -2
        
        let scale = size.width / mainMenuBackground.size.width
        mainMenuBackground.setScale(scale)
        addChild(mainMenuBackground)
        
        let escurecidoBackground = SKSpriteNode(imageNamed: "EscurecimentoBackgroundMainMenu")
        escurecidoBackground.size = self.size
        escurecidoBackground.position = PositionHelper.singleton.centralize(SKNode())
        escurecidoBackground.zPosition = -1
        addChild(escurecidoBackground)
        
        let mainMenuTitle = SKSpriteNode(imageNamed: "MainMenuTitle2")
        
        let proportion = self.frame.width / mainMenuTitle.frame.width
        mainMenuTitle.setScale(proportion)
        
        let yPosition = self.size.height - (mainMenuTitle.size.height / 1.5) // Ajusta para alinhar pelo topo
        mainMenuTitle.position = CGPoint(x: self.size.width / 2, y: yPosition)
        
        //mainMenuTitle.position = PositionHelper.singleton.centralizeQuarterUp(SKNode())
        addChild(mainMenuTitle)
        
    }
    
    private func setupButton (_ text : String, yPosition : CGFloat, number : Int) {
        
        let label = SKLabelNode(text: text)
        label.position = PositionHelper.singleton.centralize(SKLabelNode())
        label.position.y -= yPosition
        label.fontName = "Lora-Medium"
        label.fontSize = 20
        self.addChild(label)
        
        let littleButtonOnTheLeft = SKSpriteNode(imageNamed: "seta")
        littleButtonOnTheLeft.name = "seta\(number)"
        littleButtonOnTheLeft.position.x = label.position.x - label.frame.width / 1.5
        littleButtonOnTheLeft.position.y = label.position.y + (label.frame.height / 2.5)
        let proportion = 25 / littleButtonOnTheLeft.frame.width
        littleButtonOnTheLeft.setScale(proportion)
        addChild(littleButtonOnTheLeft)
         
    }
    
    override func keyDown(with event: NSEvent) {
        switch menuState {
        case .CHOOSE_OPTION:
            chooseOption(event)
        case .CONFIRM_RESET:
            warning.keyDown(event)
        }
    }
    
    private func chooseOption (_ event : NSEvent) {
        if event.keyCode == 0x7E { // seta para cima
            if selectedButton > 0 {
                self.selectedButton -= 1
            }
        }
        
        if event.keyCode == 0x7D { // seta para baixo
            if selectedButton < 1 {
                self.selectedButton += 1
            }
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
        self.menuState = .CONFIRM_RESET
    }
    
    private func goConfiguration () {
        let configurationsScene = ConfigurationsScene(size: self.size)
        configurationsScene.scaleMode = .aspectFill
        let transition = SKTransition.fade(withDuration: 1.0)
        self.view?.presentScene(configurationsScene, transition: transition)
    }
    
    private func goMainHallScene () {
        if let scene = SKScene(fileNamed: "MainHallScene.sks") {
            scene.scaleMode = .aspectFill
            let transition = SKTransition.fade(withDuration: 1.0)
            self.view?.presentScene(scene, transition: transition)
        } else {
            print("Failed to load Cutscene.")
        }
    }
    
    private func updateSetas () {
        for child in children {
            if let childName = child.name {
                if childName.starts(with: "seta") {
                    if childName == "seta\(selectedButton)" {
                        child.isHidden = false
                    } else {
                        child.isHidden = true
                    }
                }
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        updateSetas()
    }
}
