//
//  UIBatalhaScene.swift
//  JourneyThroughCastleSky
//
//  Created by Caio Marques on 13/09/24.
//

import Foundation
import SpriteKit

extension BatalhaScene{
    
    // MARK: SETUP UI
    
    func setupEnemyScreen() {
        let enemyScreen = SKSpriteNode(imageNamed: "BG-Battle")
        enemyScreen.size = CGSize(width: self.size.width, height: self.size.height*0.48)
        enemyScreen.position = CGPoint(x:  self.size.width/6400, y: self.size.height/3.75)
        
        let enemySprite = enemy.spriteComponent.sprite.copy() as! SKSpriteNode
        enemySprite.physicsBody = nil
        enemySprite.position = .zero
        enemyScreen.addChild(enemySprite)
        
        addChild(enemyScreen)
    }
    
    func setupRows() {
        let numberOfRows = 4
        let totalHeightAvailable = self.size.height * 0.45
        let rowHeight = totalHeightAvailable / CGFloat(numberOfRows)
        
        var rowNodes: [SKSpriteNode] = []
        
        for i in 0..<numberOfRows {
            let individualRow = SKSpriteNode(imageNamed: "buttonUnselected")
        
            individualRow.position = CGPoint(x: 1000, y: 100)
            
            individualRow.name = "rowButton\(i)"
            
            let label = SKLabelNode(text: returnButtonLabel(i))
            
            label.position.x = 0 - (individualRow.frame.width / 2)
            label.position.y = 0 - (individualRow.frame.height / 2) - (label.frame.height / 2)
            label.position.y -= CGFloat(Int(rowHeight) * i)

            individualRow.addChild(label)
            
            addChild(individualRow)
            rowNodes.append(individualRow)
        }
        updateColorChooseOption()
    }
    
    func setupItemRows () {
        guard let actionDescription else {return}
        
        var i = 0
        for item in User.singleton.inventoryComponent.itens {
            var rowNodes: [SKSpriteNode] = []
            
            let individualRow = SKSpriteNode(imageNamed: "buttonUnselected")
            individualRow.position = .zero
            
            individualRow.position.x += (individualRow.frame.width / 2) - 3
            individualRow.position.y -= (individualRow.frame.height / 2)
            individualRow.position.y -= (individualRow.frame.height) * CGFloat(i)
            if i != 0 {
                individualRow.position.y -= 2
            }
                
            individualRow.name = "itemRow\(i)"
                
            let label = SKLabelNode(text: item.consumableComponent?.nome)
                
            label.position.x = .zero
            label.position.y = .zero

            individualRow.addChild(label)
                
            addChild(individualRow)
            rowNodes.append(individualRow)
            i += 1
        }
        
        refreshItemState()
    }
    
    func removeAllItemRows () {
        for child in children {
            if let name = child.name {
                if name.starts(with: "itemRow") {
                    child.removeFromParent()
                }
            }
        }
    }
    
    func returnButtonLabel (_ index : Int) -> String {
        if index == 0 {
            return "Attack"
        } else if index == 1 {
            return "Items"
        } else if index == 2 {
            return "Dodge"
        } else {
            return "Skill"
        }
    }
        
    func setupActionDescription() {
        actionDescription = SKSpriteNode(imageNamed: "textbox")
        actionDescription?.size = CGSize(width: self.size.width*0.6, height: self.size.height*0.4)
        actionDescription?.position = CGPoint(x: 190, y: -self.size.height * 0.225)

        guard let actionDescription else { return }
        
        descriptionLabel = SKLabelNode(text: "init")
        guard let descriptionLabel else { return }
        descriptionLabel.fontSize = 12
        descriptionLabel.position = CGPoint(x: descriptionLabel.frame.width / 2, y: -descriptionLabel.frame.height / 2)
        
        actionDescription.addChild(descriptionLabel)
        
        addChild(actionDescription)
    }
        
    internal func setupHealthBar() {
        let backgroundHealthBar = SKSpriteNode(imageNamed: "lifeBar")
        
        backgroundHealthBar.size = CGSize(width: self.size.width * 0.2, height: self.size.height * 0.05)
        backgroundHealthBar.position = CGPoint(x: 30, y: -30)
        backgroundHealthBar.zPosition = 100
        
        addChild(backgroundHealthBar)
        
        healthBar = SKShapeNode(rectOf: CGSize(width: backgroundHealthBar.size.width - 4, height: backgroundHealthBar.size.height - 4), cornerRadius: 100)
        guard let healthBar else { return }
        
        healthBar.fillColor = .green
        healthBar.strokeColor = .clear
        healthBar.position = CGPoint(x: backgroundHealthBar.position.x - 30, y: backgroundHealthBar.position.y + 30)
        
        backgroundHealthBar.addChild(healthBar)
    }
    
    internal func updateHealthBar () {
        
        let lifePercentage : CGFloat = CGFloat(User.singleton.healthComponent.health) / CGFloat(User.singleton.healthComponent.maxHealth)
        let scaleAction = SKAction.scaleX(to: lifePercentage, duration: 0.2)
        
        healthBar?.run(scaleAction)
    }
        
    internal func setupStaminaBar() {
        // Carrega o fundo da barra de estamina a partir de um arquivo .sks
        let staminaBackgroundBar = SKSpriteNode(imageNamed: "staminaBar") // Substitua "staminaBarBackground" pelo nome do seu arquivo
        
        staminaBackgroundBar.size = CGSize(width: self.size.width * 0.2, height: self.size.height * 0.05)
        staminaBackgroundBar.position = CGPoint(x: 300, y: -30)
        
        addChild(staminaBackgroundBar)
        
        // Configura a barra de estamina como um SKShapeNode menor dentro do SKSpriteNode de fundo
        staminaBar = SKShapeNode(rectOf: CGSize(width: staminaBackgroundBar.size.width - 4, height: staminaBackgroundBar.size.height - 4), cornerRadius: 10)
        guard let staminaBar else { return }
        
        staminaBar.fillColor = .purple
        staminaBar.strokeColor = .clear
        staminaBar.position = CGPoint(x: staminaBackgroundBar.position.x - 300, y: staminaBackgroundBar.position.y + 30)
        
        staminaBackgroundBar.addChild(staminaBar)
    }
    
    internal func updateStamineBar () {
        // calcular percentual estamina
        let staminePercentage : CGFloat = CGFloat(User.singleton.staminaComponent.stamina) / CGFloat(100)
        let scaleAction = SKAction.scaleX(to: staminePercentage, duration: 0.4)
        staminaBar?.run(scaleAction)
    }
    
    func setupEnemyLifeBar () {
        let backgroundEnemyLifeBar = SKSpriteNode(imageNamed: "lifeBar")
        
        backgroundEnemyLifeBar.position = CGPoint(x: 400, y: 500)
        
        addChild(backgroundEnemyLifeBar)
        
        enemyLifeBar = SKSpriteNode(color: .red, size: CGSize(width: backgroundEnemyLifeBar.frame.width - 4, height: backgroundEnemyLifeBar.frame.height - 4))
        guard let enemyLifeBar else {return}
        enemyLifeBar.position = CGPoint(x: backgroundEnemyLifeBar.position.x, y: backgroundEnemyLifeBar.position.y)

        backgroundEnemyLifeBar.addChild(enemyLifeBar)
    }
    
    internal func updateEnemyLifeBar () {
        // calcular percentual estamina
        let enemyLifePercentage : CGFloat = CGFloat(enemy.healthComponent.health) / CGFloat(enemy.healthComponent.maxHealth)
        let scaleAction = SKAction.scaleX(to: enemyLifePercentage, duration: 0.2)
        enemyLifeBar?.run(scaleAction)
    }
    
    internal func updateDescriptionLabel () {
        var newText = ""
        
        if gameChooseState != .SELECTED && gameChooseState != .NONE {
            switch buttonSelected {
            case .ATTACK:
                newText = "Ataque o seu inimigo causando \(User.singleton.fighterComponent.damage) de dano"
            case .USE_ITEM:
                newText = ""
            case .DODGE:
                newText = "Desviar do inimigo na próxima rodada."
            case .SKILL:
                newText = "Usar alguma habilidade"
            }
        }
        
        self.descriptionLabel?.text = newText
    }
}
