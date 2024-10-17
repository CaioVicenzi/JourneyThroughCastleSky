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
    
    func setupEnemyScreen(){
        //let enemyScreen = SKShapeNode(rect: CGRect(x: -(self.size.width*0.925)/2, y: 0, width: self.size.width*0.925, height: self.size.height*0.45))
        let enemyScreen = SKShapeNode(rectOf: CGSize(width: self.size.width*0.925, height: self.size.height*0.45))
        enemyScreen.position = .zero
        enemyScreen.position.y += (enemyScreen.frame.height / 2)
        
        enemyScreen.fillColor = .black
        enemyScreen.strokeColor = .black
        
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
        
        var rowNodes: [SKShapeNode] = []
        
        for i in 0..<numberOfRows {
            let individualRow = SKShapeNode(rect: CGRect(x: -(self.size.width * 0.925) / 2,
                                                         y: (-self.size.height * 0.45)/5 - (CGFloat(i) * rowHeight),
                                                         width: self.size.width * 0.4625,
                                                         height: rowHeight))
            
            individualRow.fillColor = .gray
            individualRow.strokeColor = .black
            
            //individualRow.isUserInteractionEnabled = true
            
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
            var rowNodes: [SKShapeNode] = []
            
            let individualRow = SKShapeNode(rectOf: CGSize(width: actionDescription.frame.width, height: 100))
            individualRow.position = .zero
            
            individualRow.position.x += (individualRow.frame.width / 2) - 3
            individualRow.position.y -= (individualRow.frame.height / 2)
            individualRow.position.y -= (individualRow.frame.height) * CGFloat(i)
            if i != 0 {
                individualRow.position.y -= 2
            }
            
            individualRow.fillColor = .gray
            individualRow.strokeColor = .black
                
                
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
            return "Run"
        }
    }
        
    func setupActionDescription(){
        actionDescription = SKShapeNode(rect: CGRect(x: (self.size.width*0.925)/2, y: -self.size.height*0.45, width: -self.size.width*0.4625, height: self.size.height*0.45))
        
        guard let actionDescription else {return}
            
        actionDescription.fillColor = .yellow
        actionDescription.strokeColor = .black
            
        addChild(actionDescription)
    }
        
    internal func setupHealthBar(){
        //let backgroundHealthBar = SKShapeNode(rect: CGRect(x: -(self.size.width*0.925)/2, y: 0, width: self.size.width*0.4625, height: self.size.height*0.045))
        let backgroundHealthBar = SKShapeNode(rectOf: CGSize(width: self.size.width * 0.4625, height: self.size.height*0.045))
        
        backgroundHealthBar.position = .zero
        backgroundHealthBar.position.x -= backgroundHealthBar.frame.width / 2
        backgroundHealthBar.position.y += backgroundHealthBar.frame.height / 2
            
        backgroundHealthBar.fillColor = .darkGray
        backgroundHealthBar.strokeColor = .black
            
        addChild(backgroundHealthBar)
        
        healthBar = SKShapeNode(rect: backgroundHealthBar.frame)
        guard let healthBar else {return}
        
        healthBar.position = .zero
        healthBar.position.x += (healthBar.frame.width / 2)
        healthBar.position.y -= (healthBar.frame.height / 2)
        healthBar.fillColor = .green
        
        backgroundHealthBar.addChild(healthBar)
    }
    
    internal func updateHealthBar () {
        
        // calcular percentual vida
        let lifePercentage : CGFloat = CGFloat(User.singleton.healthComponent.health) / CGFloat(User.singleton.healthComponent.maxHealth)
        let scaleAction = SKAction.scaleX(to: lifePercentage, duration: 1.0)//SKAction.scale(to: lifePercentage, duration: 1.0)
        
        healthBar?.run(scaleAction)
    }
        
    func setupStaminaBar(){
        let staminaBackgroundBar = SKShapeNode(rectOf: CGSize(width: (self.size.width*0.925) / 2, height: self.size.height*0.045))
        
        staminaBackgroundBar.position = .zero
        staminaBackgroundBar.position.x += staminaBackgroundBar.frame.width / 2
        staminaBackgroundBar.position.y += staminaBackgroundBar.frame.height / 2
        staminaBackgroundBar.fillColor = .darkGray
        staminaBackgroundBar.strokeColor = .black
        
        addChild(staminaBackgroundBar)
        
        staminaBar = SKShapeNode(rect: staminaBackgroundBar.frame)
        staminaBar?.position = .zero
        guard let staminaBar else {return}

        staminaBar.position.y -= staminaBar.frame.height / 2
        staminaBar.position.x -= staminaBar.frame.width / 2
        
        
        staminaBar.fillColor = .purple
        
        staminaBackgroundBar.addChild(staminaBar)
    }
    
    internal func updateStamineBar () {
        // calcular percentual estamina
        let staminePercentage : CGFloat = CGFloat(User.singleton.staminaComponent.stamina) / CGFloat(100)
        let scaleAction = SKAction.scaleX(to: staminePercentage, duration: 1.0)
        staminaBar?.run(scaleAction)
    }
    
    
}
