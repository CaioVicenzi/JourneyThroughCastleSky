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
        self.enemyScreen = SKSpriteNode(imageNamed: "BG-Battle")
        guard let enemyScreen else {return}
        
        enemyScreen.size = CGSize(width: self.size.width, height: self.size.height*0.48)
        enemyScreen.position = CGPoint(x:  self.size.width/6400, y: self.size.height/3.75)
        
        let enemySprite = enemy.spriteComponent.fighterSprite.copy() as! SKSpriteNode
        
        let enemyScreenSize = enemyScreen.calculateAccumulatedFrame().size
        let enemySpriteTexture = enemySprite.texture!.size()
        let inverseEnemySpriteAspectRatio = 1 / (enemySpriteTexture.width / enemySpriteTexture.height)
        
        let enemySpriteHeight = enemyScreenSize.height - 50
        
        let enemySpriteSize = CGSize(
            width: (enemySpriteHeight - 50) * inverseEnemySpriteAspectRatio,
            height: enemySpriteHeight
        )
        
        enemySprite.size = enemySpriteSize
        
        enemySprite.physicsBody = nil
        enemySprite.position = .zero
        enemyScreen.addChild(enemySprite)
        enemySprite.zPosition = 5
        
        addChild(enemyScreen)
    }
    
    func setupRows() {
        let numberOfRows = 4
        let totalHeightAvailable = self.size.height * 0.45
        let rowHeight = totalHeightAvailable / CGFloat(numberOfRows)
        let offsetY: CGFloat = -180
        let startingY = totalHeightAvailable / 2 + offsetY// Start from top of the available area
        
        for i in 0..<numberOfRows {
            let individualRow = SKSpriteNode(imageNamed: "buttonUnselected")
            individualRow.anchorPoint = .init(x: 0, y: 1)
            let proporcao = (rowHeight - 70) / individualRow.frame.height
            individualRow.setScale(proporcao)
            
            // Calculate the y-position for each row, spacing them evenly
            let yPosition = startingY - (CGFloat(i) * rowHeight) - rowHeight / 2
            individualRow.position = CGPoint(
                x: -320,
                y: yPosition
            )
            individualRow.name = "rowButton\(i)"

            
            let label = SKLabelNode(text: returnButtonLabel(i).uppercased())
            label.position = CGPoint(x: 0, y: -label.frame.height / 2)
            label.zPosition = 5
            label.fontColor = .black
            label.fontName = "Lora-Medium"
            label.fontSize = 48
            
            individualRow.addChild(label)
            
            addChild(individualRow)
            
            updateButtonsState()
        }
    }

    func setupItemRows() {
        guard actionDescription != nil else { return }
        
        for (i, item) in User.singleton.inventoryComponent.itens.enumerated() {
            let individualRow = SKSpriteNode(imageNamed: "buttonUnselected")
            let proportion =  200 / individualRow.frame.width
            individualRow.setScale(proportion)
            
            //let rowWidth = individualRow.calculateAccumulatedFrame().size.width
            let rowHeight = individualRow.calculateAccumulatedFrame().size.height
            
            let xPosition = actionDescription!.calculateAccumulatedFrame().size.width * -0.5 + 10
            let yPosition = actionDescription!.calculateAccumulatedFrame().size.height * 0.5 - 30 - CGFloat(
                i
            ) * (rowHeight + 5)
            individualRow.anchorPoint = .init(x: 0, y: 1)
            individualRow.position = CGPoint(x: xPosition, y: yPosition)
            
            individualRow.name = "itemRow\(i)"
            individualRow.zPosition = 100
            
            let label = SKLabelNode(text: item.nameComponent.name)
            label.fontName = "Lora"
            label.fontSize = 20
            label.position = .init(
                x: individualRow.frame.width,
                y: (rowHeight + label.frame.size.height) * -1
            )
            
            individualRow.addChild(label)
            
            if let itemName = item.consumableComponent?.nome {
                let labelSprite = SKSpriteNode(texture: SKTexture(imageNamed: itemName))
                labelSprite.position = .zero
                individualRow.addChild(labelSprite)
            }
            actionDescription!.addChild(individualRow)
        }
        
        refreshItemState()
    }

    func removeAllItemRows() {
        for child in children {
            if let name = child.name, name.starts(with: "itemRow") {
                child.removeFromParent()
            }
        }
    }

    func returnButtonLabel(_ index: Int) -> String {
        switch index {
        case 0:
            return "Ataque"
        case 1:
            return "Itens"
        case 2:
            return "Esquivar"
        default:
            return "Habilidades"
        }
    }
        
    func setupActionDescription(){
        actionDescription = SKSpriteNode(imageNamed: "textbox")
        actionDescription?.size = CGSize(width: self.size.width*0.6, height: self.size.height*0.4)
        actionDescription?.position = CGPoint(x: 190, y: -self.size.height * 0.225)

        guard let actionDescription else { return }
        
        descriptionLabel = SKLabelNode(text: "init")
        guard let descriptionLabel else { return }
        descriptionLabel.fontSize = 24
        descriptionLabel.position = CGPoint(x: descriptionLabel.frame.width / 2, y: -descriptionLabel.frame.height / 2)
        descriptionLabel.fontName = "Lora-Medium"
        
        
        actionDescription.addChild(descriptionLabel)
        
        addChild(actionDescription)
    }
        
    internal func setupHealthBar() {
        let backgroundHealthBar = SKSpriteNode(imageNamed: "lifeBar")
        
        backgroundHealthBar.size = CGSize(width: self.size.width * 0.2, height: self.size.height * 0.05)
        backgroundHealthBar.position = CGPoint(x: 30, y: -30)
        backgroundHealthBar.zPosition = 100
        
        addChild(backgroundHealthBar)
        
        // Configura a barra de estamina como um SKShapeNode menor dentro do SKSpriteNode de fundo
        let rect = CGSize(width: backgroundHealthBar.size.width - 20, height: backgroundHealthBar.size.height - 10)
        
        healthBar = SKSpriteNode(color: .wine, size: rect)
        healthBar?.anchorPoint = CGPoint(x: 0, y: 0.5)
        guard let healthBar else { return }
        healthBar.position = CGPoint(x: -(backgroundHealthBar.size.width / 2) + 10, y: 0) // Ajuste de posição para alinhar à esquerda
        healthBar.position = backgroundHealthBar.position
        healthBar.position.x -= healthBar.frame.width / 2
        healthBar.zPosition = backgroundHealthBar.zPosition - 1
        addChild(healthBar)
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
        let rect = CGSize(width: staminaBackgroundBar.size.width - 20, height: staminaBackgroundBar.size.height - 10)
        //guard let rect else {print("erro, não conseguimos fazer o rect do BatalheScenem na barra de estamina"); return}
        
        staminaBar = SKSpriteNode(color: .darkGold, size: rect)
        staminaBar?.anchorPoint = CGPoint(x: 0, y: 0.5)
        guard let staminaBar else { return }
        staminaBar.position = staminaBackgroundBar.position // Ajuste de posição para alinhar à esquerda
        staminaBar.position.x -= (staminaBar.frame.width / 2)
        staminaBar.zPosition = staminaBackgroundBar.zPosition - 1

        addChild(staminaBar)
    }
    
    internal func updateStamineBar () {
        // calcular percentual estamina
        let staminePercentage : CGFloat = CGFloat(User.singleton.staminaComponent.stamina) / CGFloat(100)
        let scaleAction = SKAction.scaleX(to: staminePercentage, duration: 0.4)
        staminaBar?.run(scaleAction)
    }
    
    func setupEnemyLifeBar () {
        guard let enemyScreen else {
            return
        }
        
        let backgroundEnemyLifeBar = SKSpriteNode(imageNamed: "lifeBar")
        
        backgroundEnemyLifeBar.setScale(0.5)
        backgroundEnemyLifeBar.position = .zero
        backgroundEnemyLifeBar.position.y += (enemyScreen.frame.height / 2) - (backgroundEnemyLifeBar.frame.height / 2) - 40
        backgroundEnemyLifeBar.position.x += (enemyScreen.frame.width / 2) - (backgroundEnemyLifeBar.frame.width / 2) - 40
        backgroundEnemyLifeBar.zPosition = 5
        
        enemyScreen.addChild(backgroundEnemyLifeBar)
                
        enemyLifeBar = SKSpriteNode(color: .wine, size: CGSize(width: (backgroundEnemyLifeBar.frame.width) - 30, height: backgroundEnemyLifeBar.frame.height - 3))
        guard let enemyLifeBar else {return}
        enemyLifeBar.position = .zero
        enemyLifeBar.position = backgroundEnemyLifeBar.position
        
        enemyLifeBar.position.x -= enemyLifeBar.frame.width / 2
        enemyLifeBar.anchorPoint = CGPoint(x: 0, y: 0.5)
        enemyLifeBar.zPosition = 4

        
        enemyScreen.addChild(enemyLifeBar)
    }
    
    internal func updateEnemyLifeBar () {
        // calcular percentual estamina
        let enemyLifePercentage : CGFloat = CGFloat(enemy.healthComponent.health) / CGFloat(enemy.healthComponent.maxHealth)
        let scaleAction = SKAction.scaleX(to: enemyLifePercentage, duration: 0.2)
        enemyLifeBar?.run(scaleAction)
        enemyLifeBar?.zPosition = 4
    }
    
    internal func updateDescriptionLabel () {
        var newText = ""
        
        if gameChooseState != .SELECTED && gameChooseState != .NONE {
            switch buttonSelected {
            case .ATTACK:
                newText = "Ataque o seu inimigo causando \(User.singleton.fighterComponent.damage) de dano"
            case .USE_ITEM:
                newText = "Usar um item"
            case .DODGE:
                newText = "Desviar do inimigo na próxima rodada."
            case .SKILL:
                newText = "Usar alguma habilidade"
            }
        }
        
        if (gameChooseState == .CHOOSE_ITEM) {
            newText = ""
        }
        
        self.descriptionLabel?.text = newText
    }
    
    internal func updateButtonsState () {
        for i in 0 ..< 4 {
            if let child = self.childNode(withName: "rowButton\(i)") as? SKSpriteNode {
                let individualRow : SKSpriteNode

                if gameChooseState == .SELECTED {
                    individualRow = SKSpriteNode(imageNamed: "buttonUnselected")
                } else {
                    if i == buttonSelected.rawValue {
                        individualRow = SKSpriteNode(imageNamed: "buttonSelected")
                    } else {
                        individualRow = SKSpriteNode(imageNamed: "buttonUnselected")
                    }
                }
                
                addChild(individualRow)
                for childChild in child.children {
                    childChild.removeFromParent()
                    individualRow.addChild(childChild)
                }
                
                let numberOfRows = 4
                let totalHeightAvailable = self.size.height * 0.45
                let rowHeight = totalHeightAvailable / CGFloat(numberOfRows)
                let proporcao = (rowHeight) / individualRow.frame.height
                individualRow.setScale(proporcao)
                individualRow.position = child.position
                individualRow.name = child.name
                child.removeFromParent()
            }
        }
    }
}
