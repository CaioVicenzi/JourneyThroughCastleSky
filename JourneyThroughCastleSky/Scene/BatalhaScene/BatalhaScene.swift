//
//  BatalhaScene.swift
//  JourneyThroughCastleSky
//
//  Created by Caio Marques on 11/09/24.
//

import Foundation
import SpriteKit

class BatalhaScene : SKScene {
    var enemy : Enemy!
    var buttonAttack = SKShapeNode()
    var buttonUseItem = SKShapeNode()
    var buttonSpare = SKShapeNode()
    var myLifeLabel = SKLabelNode()
    var enemyLifeLabel = SKLabelNode()
    
    var previousScene : SKScene? = nil
    
    private var buttonSelected : ButtonSelected = .ATTACK
    private var gameChooseState : chooseState = .CHOOSE_BUTTON
    private var positionItemSelected = 0
    private var enemyDodge = false
    
    func config (_ scene : SKScene) {
        self.previousScene = scene
    }
    
    enum ButtonSelected : Int {
        case ATTACK = 0
        case USE_ITEM = 1
        case SPARE = 2
    }
    
    enum chooseState {
        case NONE
        case CHOOSE_BUTTON
        case CHOOSE_ITEM
        case SELECTED
    }
    
    override func didMove(to view: SKView) {
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        setupNodes()
    }
    
    func setupNodes () {
        setupEnemyScreen()
        setupRows()
        setupStaminaBar()
        setupHealthBar()
        setupActionDescription()
    }
    
    func config (enemy : Enemy) {
        self.enemy = enemy
    }
    
    override func mouseDown(with event: NSEvent) {
        let location = event.location(in: self)
            
        let touchedNode = atPoint(location)
        
        if let nodeName = touchedNode.name, nodeName.starts(with: "rowButton") {
            handleButtonPress(named: nodeName)
        }
    }
    
    // MARK: LÓGICA
    
    override func keyDown(with event: NSEvent) {
        switch gameChooseState {
        case .NONE:
            return
        case .CHOOSE_BUTTON:
            chooseButton(event.keyCode)
        case .CHOOSE_ITEM:
            chooseItem(event.keyCode)
        case .SELECTED:
            return
        }
        refreshButtonsState()
    }
    
    private func chooseButton (_ keyCode : UInt16) {
        switch keyCode {
        case 123: // Seta para a esquerda
            if let proximoButton = ButtonSelected(rawValue: buttonSelected.rawValue - 1) {
                let buttonAtual = buttonSelected
                
                if buttonAtual == .SPARE {
                    if User.singleton.inventoryComponent.itens.isEmpty {
                        buttonSelected = .ATTACK
                    } else {
                        buttonSelected = .USE_ITEM
                    }
                } else {
                    buttonSelected = proximoButton
                }
            }
            
            
        case 124: // Seta para a direita
            if let proximoButton = ButtonSelected(rawValue: buttonSelected.rawValue + 1) {
                let buttonAtual = buttonSelected
                
                if buttonAtual == .ATTACK {
                    if User.singleton.inventoryComponent.itens.isEmpty {
                        buttonSelected = .SPARE
                    } else {
                        buttonSelected = .USE_ITEM
                    }
                } else {
                    buttonSelected = proximoButton
                }
            }
        case 36:
            switch buttonSelected {
            case .ATTACK:
                attack()
                gameChooseState = .SELECTED
            case .USE_ITEM:
                useItem()
                gameChooseState = .CHOOSE_ITEM
            case .SPARE:
                spare()
                gameChooseState = .SELECTED
            }
            
            if gameChooseState == .SELECTED {
                self.buttonSelected = ButtonSelected(rawValue: 0) ?? .ATTACK
                enemyTurn()
            }
            
        default:
            return
        }
    }
    
    private func chooseItem (_ keyCode : UInt16) {
        refreshItemState()
        switch keyCode {
        case 123: // Seta para a esquerda
            if positionItemSelected > 0 {
                positionItemSelected -= 1
            }
            refreshItemState()
        case 124: // Seta para a direita
            if positionItemSelected < User.singleton.inventoryComponent.itens.count - 1 {
                positionItemSelected += 1
            }
            refreshItemState()
        case 36:
            //User.singleton.useItem(by: positionItemSelected, label: self.myLife)
            useItem(User.singleton.inventoryComponent.itens[positionItemSelected])
            positionItemSelected = 0
            enemyTurn()
            
        default:
            return
        }
    }
    
    private func useItem (_ item : Item) {
        if item.consumableComponent?.effect.type == .CURE {
            User.singleton.healthComponent.health += item.consumableComponent?.effect.amount ?? 0
            myLifeLabel.text = "Life: \(User.singleton.healthComponent.health)"
        } else if item.consumableComponent?.effect.type == .DAMAGE {
            User.singleton.fighterComponent.damage += item.consumableComponent?.effect.amount ?? 0
        }
    }
    
    private func enemyTurn () {
        buttonSpare.removeFromParent()
        buttonAttack.removeFromParent()
        buttonUseItem.removeFromParent()
        
        var index : Int = 0
        for _ in User.singleton.inventoryComponent.itens {
            let node = self.childNode(withName: "quadradoItem\(index)")
            node?.removeFromParent()
            index += 1
        }
        let node = self.childNode(withName: "quadradoItem\(index + 1)")
        node?.removeFromParent()
        for node in self.children {
            if node.name?.hasPrefix("quadradoItem") == true {
                node.removeFromParent()
            }
        }
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: { [weak self] in
            let label = SKLabelNode()
            
            
            let randomico = Int.random(in: 0 ..< 2)
            if randomico == 0 {
                User.singleton.healthComponent.health -= 10
                if User.singleton.healthComponent.health <= 0 {
                    if let self {
                        self.view?.presentScene(GameOverScene(size: self.size))
                    }
                }
                self?.myLifeLabel.text = "Life: \(User.singleton.healthComponent.health)"
                label.text = "Inimigo atacou!"
            } else {
                self?.enemyDodge = true
                label.text = "Inimigo esperou..."
            }
            
            label.position = PositionHelper.singleton.centralize(label)
            self?.addChild(label)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: { [weak self] in
                label.removeFromParent()
                
                if let self {
                    self.addChild(self.buttonSpare)
                    self.addChild(self.buttonAttack)
                    self.addChild(self.buttonUseItem)
                    self.gameChooseState = .CHOOSE_BUTTON
                }
            })
        })
    }
    
    private func attack () {
        if enemyDodge {
            let messageEnemyDodge = SKLabelNode(text: "Inimigo se esquivou")
            messageEnemyDodge.position = PositionHelper.singleton.centralize(messageEnemyDodge)
            scene?.addChild(messageEnemyDodge)
            
            enemy.spriteComponent.sprite.position.x += 100
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: { [weak self] in
                messageEnemyDodge.removeFromParent()
                self?.enemyDodge = false
                self?.enemy.spriteComponent.sprite.position.x -= 100
            })
        } else {
            
            enemy.healthComponent.health -= User.singleton.fighterComponent.damage
            enemyLifeLabel.text = "Life: \(enemy.healthComponent.health)"
            
            if enemy.healthComponent.health <= 0 {
                let nextScene = YouWinScene(size: self.size)
                nextScene.scaleMode = .aspectFill
                
                let transition = SKTransition.fade(withDuration: 1.0)
                self.view?.presentScene(nextScene, transition: transition)
            }
        }
    }
    
    private func spare () {
        let nextScene = GameScene(size: self.size)
        nextScene.scaleMode = .aspectFill
        
        let transition = SKTransition.fade(withDuration: 1.0)
        enemy.spriteComponent.sprite.removeFromParent()
        
        if let previousScene = previousScene as? GameScene {
            //reviousScene.setupEnemy(enemy)
            User.singleton.positionComponent.xPosition -= 40
            User.singleton.spriteComponent.sprite.position.x -= 40
            User.singleton.spriteComponent.sprite.removeFromParent()
            
            self.view?.presentScene(previousScene, transition: transition)
        }
    }
    
    private func useItem () {
        // PRIMEIRO PASSO: ELIMINAR OS BOTÕES POSSÍVEIS
        buttonSpare.removeFromParent()
        buttonAttack.removeFromParent()
        buttonUseItem.removeFromParent()
        
        var referencia : Int = 150
        var referencia2 : Int = 0
        var itemNumber : Int = 0
        
        // SEGUNDO PASSO: ADICIONAR OS ITENS NA TELA
        User.singleton.inventoryComponent.itens.forEach { item in            
            let quadrado = SKShapeNode(rect: CGRect(origin: PositionHelper.singleton.centralizeQuarterLeft(buttonAttack), size: CGSize(width: 100, height: 50)))
            quadrado.position.x += CGFloat(referencia)
            quadrado.fillColor = .gray
            referencia += 150
            
            
            let itemSprite = item.spriteComponent.sprite
            itemSprite.scale(to: CGSize(width: 40, height: 40))
            itemSprite.position = CGPoint(x: 200, y: 150)
            itemSprite.position.x += CGFloat(referencia2)
            referencia2 += 10
            
            quadrado.addChild(itemSprite)
            quadrado.name = "quadradoItem\(itemNumber)"
            itemNumber += 1
            
            addChild(quadrado)
        }
    }
    
    private func refreshButtonsState () {
        if buttonSelected == .ATTACK {
            buttonAttack.fillColor = .red
            buttonSpare.fillColor = .gray
            buttonUseItem.fillColor = .gray
        } else if buttonSelected == .SPARE {
            buttonAttack.fillColor = .gray
            buttonSpare.fillColor = .blue
            buttonUseItem.fillColor = .gray
        } else {
            buttonAttack.fillColor = .gray
            buttonSpare.fillColor = .gray
            buttonUseItem.fillColor = .yellow
        }
    }
    
    private func refreshItemState () {
        for i in 0 ..< User.singleton.inventoryComponent.itens.count {

            let node = self.childNode(withName: "quadradoItem\(i)") as! SKShapeNode
            if i == positionItemSelected {
                node.fillColor = .blue
            } else {
                node.fillColor = .gray
            }
        }
    }
}

