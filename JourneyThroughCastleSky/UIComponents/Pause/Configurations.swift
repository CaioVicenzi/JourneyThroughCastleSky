//
//  Configurations.swift
//  Memorance
//
//  Created by Caio Marques on 18/11/24.
//

import Foundation
import SpriteKit

class Configurations {
    // VARIÁVEIS RECEBIDAS POR PARÂMETRO
    var skScene : TopDownScene?
    var pause : Pause?
    
    var languageBar : SKSpriteNode?
    var musicBar : SKSpriteNode?
    var effectsBar : SKSpriteNode?
    
    var selectedBar : Int = 1
    
    var musicLevel : Int = 0
    var effectsLevel : Int = 0
    
    var configurationsSprite : SKSpriteNode?
        
    init(_ pause: Pause) {
        self.skScene = pause.gameScene
        self.pause = pause
        
        self.musicLevel = Int((BackgroundMusicHelper.singleton.audioPlayer?.volume ?? 1.0) * 10)
    }
    
    func setupConfigurations () {
        configurationsSprite = SKSpriteNode(imageNamed: "itemsInventory")
        guard let configurationsSprite else {return}
        configurationsSprite.setScale(0.6)
        configurationsSprite.zPosition += 10
        configurationsSprite.position = .zero
        configurationsSprite.position.y -= 50
        pause?.pauseBackground?.addChild(configurationsSprite)
        setupConfigurationBars()
        
    }
    
    func setupConfigurationBars () {
        // idioma
        languageBar = SKSpriteNode(imageNamed: "configurationBarUnselected")
        
        guard let languageBar else {
            return
        }
        
        languageBar.position = .zero
        languageBar.position.y += 250
        languageBar.name = "bar1"
        setupBarLabel(languageBar, label: "Idioma")
        setupLanguageSelector()
        self.configurationsSprite?.addChild(languageBar)
        
        // musica
        musicBar = SKSpriteNode(imageNamed: "configurationBarUnselected")
        guard let musicBar else {
            return
        }
        musicBar.position = .zero
        musicBar.position.y += 120
        musicBar.name = "bar2"
        setupBarLabel(musicBar, label: "Música")
        setupScale(musicBar, number: 2)
        self.configurationsSprite?.addChild(musicBar)
        updatePin(2)
        /*
        
        // efeitos
        effectsBar = SKSpriteNode(imageNamed: "configurationBarUnselected")
        guard let effectsBar else {
            return
        }
        
        effectsBar.position = .zero
        effectsBar.position.y -= 30
        effectsBar.name = "bar3"
        setupScale(effectsBar, number: 3)
        setupBarLabel(effectsBar, label: "Efeitos")
        self.configurationsSprite?.addChild(effectsBar)
        updatePin(3)
         */
        updateSelectedBar()

    }
    
    private func setupLanguageSelector () {
        guard let languageBar else {
            return
        }
        
        let languageLabel = SKLabelNode()
        languageLabel.text = "Português"
        languageLabel.fontName = "Lora-Medium"
        languageLabel.numberOfLines = 1
        languageLabel.fontSize = 28
        languageLabel.position = .zero
        languageLabel.position.x += (languageBar.frame.width / 3)
        languageLabel.position.y -= languageLabel.frame.height / 4
        languageLabel.fontColor = .black
        languageBar.addChild(languageLabel)
        
        
        //Seta da direita
        let rightArrow = SKSpriteNode(imageNamed: "seta2")
        rightArrow.position = languageLabel.position
        rightArrow.setScale(0.4)
        rightArrow.position.x += languageLabel.frame.width / 2 + rightArrow.size.width + 5
        rightArrow.position.y += rightArrow.frame.height / 2.5
        languageBar.addChild(rightArrow)
        
        //Seta da esquerda
        let leftArrow = SKSpriteNode(imageNamed: "seta2")
        leftArrow.zRotation = .pi
        leftArrow.setScale(0.4)
        leftArrow.position = languageLabel.position
        leftArrow.position.y = rightArrow.position.y
        leftArrow.position.x -= (languageLabel.frame.width / 1.5)
        languageBar.addChild(leftArrow)
        
    }
    
    private func setupBarLabel (_ bar : SKSpriteNode, label : String) {
        let labelNode = SKLabelNode()
        labelNode.text = label
        labelNode.fontColor = .black
        labelNode.fontName = "Lora-Medium"
        labelNode.fontSize = 40
        labelNode.position = .zero
        labelNode.position.x -= bar.frame.width / 2
        labelNode.position.x += labelNode.frame.width
        labelNode.position.y -= labelNode.frame.height / 3
        bar.addChild(labelNode)
    }
    
    private func setupScale (_ bar : SKSpriteNode, number : Int) {
        let configurationScale = SKSpriteNode(imageNamed: "configurationScale")
        //configurationScale.setScale(0.8)
        configurationScale.position = .zero
        configurationScale.position.x += configurationScale.frame.width / 4
        configurationScale.name = "configurationScale\(number)"
        bar.addChild(configurationScale)
        
        let pin = SKSpriteNode(imageNamed: "configurationScalePin")
        pin.position = .zero
        pin.position.x -= configurationScale.frame.width / 4
        pin.position.x += 10
        pin.position.x += CGFloat((configurationScale.frame.width / 11.5) * CGFloat(number == 2 ? self.musicLevel : self.effectsLevel))
        pin.name = "pin\(number.description)"
        bar.addChild(pin)
        
        updatePin(2)
        updatePin(3)
    }
    
    func input (_ keyCode : Int) {
        let isEscKey = keyCode == 53
        let isLeftArrow = keyCode == 123
        let isRightArrow = keyCode == 124
        let isUpArrow = keyCode == 126
        let isDownArrow = keyCode == 125
        
        if isUpArrow {
            if self.selectedBar > 1 {
                self.selectedBar -= 1
                updateSelectedBar()
            }
        }
        
        if isDownArrow {
            if self.selectedBar < 2 {
                self.selectedBar += 1
                updateSelectedBar()
            }
        }
        
        if isEscKey {
            pause?.pauseState = .OPTIONS
            removeConfiguration()
        }
        
        if isLeftArrow {
            if selectedBar == 2 {
                if musicLevel > 0 {
                    self.musicLevel -= 1
                }
                updatePin(2)
                updateVolumeMusic()
            } else if selectedBar == 3 {
                if effectsLevel > 0 {
                    self.effectsLevel -= 1
                }
                updatePin(3)
            }
        }
        
        if isRightArrow {
            if selectedBar == 2 {
                if musicLevel < 10 {
                    self.musicLevel += 1
                }
                updatePin(2)
                updateVolumeMusic()
            } else if selectedBar == 3 {
                if effectsLevel < 10 {
                    self.effectsLevel += 1
                }
                updatePin(3)
            }
        }
        
        
    }
    
    func updateSelectedBar () {
        for i in 1 ... 3 {
            let spriteBar = SKSpriteNode(imageNamed: i == selectedBar ? "configurationBarSelected" : "configurationBarUnselected")
            configurationsSprite?.children.forEach({ node in
                if node.name == "bar\(i)" {
                    spriteBar.position = node.position
                    spriteBar.name = node.name
                    for child in node.children {
                        child.removeFromParent()
                        spriteBar.addChild(child)
                    }
                    node.removeFromParent()
                    configurationsSprite?.addChild(spriteBar)
                }
            })
        }
        
    }
    
    func updatePin (_ number : Int) {
        let bar = configurationsSprite?.childNode(withName: "bar\(number)")
        let pin = bar?.childNode(withName: "pin\(number)")
        let configurationScale = bar?.childNode(withName: "configurationScale\(number)")
        
        guard let configurationScale, let pin else {
            return
        }
        
        var initialValue = CGFloat.zero
        initialValue -= configurationScale.frame.width / 4
        initialValue += 30
        
        pin.position.x = initialValue
        pin.position.x += CGFloat((configurationScale.frame.width / 11.5) * CGFloat(number == 2 ? self.musicLevel : self.effectsLevel))
        
        
    }
    
    func removeConfiguration () {
        configurationsSprite?.removeAllChildren()
        configurationsSprite?.removeFromParent()
    }
    
    func updateVolumeMusic () {
        BackgroundMusicHelper.singleton.audioPlayer?.volume = Float(self.musicLevel) / 10
    }
    
    
}
