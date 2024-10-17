//
//  BatalhaScene.swift
//  JourneyThroughCastleSky
//
//  Created by Caio Marques on 11/09/24.
//

import Foundation
import SpriteKit

struct ActionResult {
    enum State {
        case cancelled
        case success
    }
    
    var state: State = .success
    
}

class BatalhaScene : SKScene {
    var enemy : Enemy!
    var buttonAttack = SKShapeNode()
    var buttonUseItem = SKShapeNode()
    var buttonSpare = SKShapeNode()
    var buttonDodge = SKShapeNode()
    var myLifeLabel = SKLabelNode()
    var enemyLifeLabel = SKLabelNode()
    
    var battleSystem = CombatSystem()
    
    var previousScene : SKScene? = nil
    
    private var buttonSelected : ButtonSelected = .ATTACK
    private var gameChooseState : chooseState = .CHOOSE_BUTTON
    private var positionItemSelected = 0
    private var enemyDodge = false
    
    var actionDescription : SKShapeNode? = nil
    var healthBar : SKShapeNode? = nil
    var staminaBar : SKShapeNode? = nil
    
    func config (_ scene : SKScene) {
        self.previousScene = scene
    }
    
    enum ButtonSelected : Int {
        case ATTACK = 0
        case USE_ITEM = 1
        case SPARE = 2
        case DODGE = 3
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
        self.gameChooseState = .CHOOSE_BUTTON
    }
    
    func setupNodes () {
        setupEnemyScreen()
        setupRows()
        setupStaminaBar()
        setupHealthBar()
        setupActionDescription()
    }
    
    func config (enemy : Enemy) {
        battleSystem.enemy = enemy
        self.enemy = enemy
    }
    
    // MARK: LÓGICA
    
    override func keyDown(with event: NSEvent) {
        if event.keyCode == 53 {
            spare()
        }
        
        #warning("isso é apenas um cheat para teste.")
        if event.keyCode == 13 {
            getOutWinning()
        }
    
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
        //refreshButtonsState()
    }
    
    internal func updateColorChooseOption () {
        print("UPDATE: \(gameChooseState)")
        
        if gameChooseState == .NONE || gameChooseState == .SELECTED {
            for index in 0 ..< 4 {
                let rowButton = childNode(withName: "rowButton\(index)") as! SKShapeNode
                rowButton.fillColor = .gray
            }
            return
        }
        
        for index in 0 ..< 4 {
            let rowButton = childNode(withName: "rowButton\(index)") as! SKShapeNode
            
            
            if index == buttonSelected.rawValue {
                rowButton.fillColor = .blue
            } else {
                rowButton.fillColor = .gray
            }
        }
    }
    
    private func chooseButton (_ keyCode : UInt16) {
        switch keyCode {
        case 126: // Seta para cima
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
                 
                updateColorChooseOption()
            }
            
            
        case 125: // Seta para baixo
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
                
                updateColorChooseOption()
            }
        case 36: // Enter
            var result: ActionResult = ActionResult()
            switch buttonSelected {
                case .ATTACK:
                    result = attack()
                    gameChooseState = .SELECTED
                case .USE_ITEM:
                    //showItems()
                    setupItemRows()
                    gameChooseState = .CHOOSE_ITEM
                case .SPARE:
                    spare()
                    gameChooseState = .SELECTED
                case .DODGE:
                    gameChooseState = .SELECTED
            }
                
            if (result.state == .cancelled) {
                gameChooseState = .CHOOSE_BUTTON
                return
            }
            
            if gameChooseState == .SELECTED {
                self.buttonSelected = ButtonSelected(rawValue: 0) ?? .ATTACK
                enemyTurn()
            }
            
            updateColorChooseOption()
            
        default:
            return
        }
    }
    
    private func chooseItem (_ keyCode : UInt16) {
        refreshItemState()
        
        switch keyCode {
        case 126: // Seta para cima
            if positionItemSelected > 0 {
                positionItemSelected -= 1
            }
            refreshItemState()
        case 125: // Seta para baixo
            if positionItemSelected < User.singleton.inventoryComponent.itens.count - 1 {
                positionItemSelected += 1
            }
            refreshItemState()
        case 36:
            useItem(User.singleton.inventoryComponent.itens[positionItemSelected])
            positionItemSelected = 0
            enemyTurn()
            
        default:
            return
        }
    }
    
    private func useItem(_ item : Item) {
        ItemSystem.useItem(item)
        User.singleton.inventoryComponent.itens.removeAll { currentItem in
            currentItem.id == item.id
        }
        myLifeLabel.text = "Life: \(User.singleton.healthComponent.health)"
        removeAllItemRows()
        updateColorChooseOption()
    }
    
    private func enemyTurn() {
        battleSystem.enemyTurn()
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
                self?.updateHealthBar()
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
                
                self?.updateColorChooseOption()
            })
        })
    }
    
    private func attack () -> ActionResult {
        
        
        let attackResult = battleSystem.attack()
        var actionResult = ActionResult()
        
        if (attackResult.cancelled) {
            actionResult.state = .cancelled
            return actionResult
        }
        
        if (attackResult.enemyDodged) {
            
            let messageEnemyDodge = SKLabelNode(text: "Inimigo se esquivou")
            messageEnemyDodge.position = PositionHelper.singleton.centralize(messageEnemyDodge)
            scene?.addChild(messageEnemyDodge)
            enemy.spriteComponent.sprite.run(.sequence([
                .move(by: .init(dx: 100, dy: 0), duration: 1),
                .move(by: .init(dx: -100, dy: 0), duration: 1)
            ]))
            
        } else {
            enemyLifeLabel.text = "Life: \(enemy.healthComponent.health)"
            if enemy.healthComponent.health <= 0 {
                let nextScene = YouWinScene(size: self.size)
                nextScene.scaleMode = .aspectFill
                
                let transition = SKTransition.fade(withDuration: 1.0)
                self.view?.presentScene(nextScene, transition: transition)
            }
        }
        
        updateStamineBar()
        return actionResult
    }
    
    private func spare () {
        
        let nextScene =  SKScene(fileNamed: "MainHallScene.sks")
        nextScene?.scaleMode = .aspectFill
        let transition = SKTransition.fade(withDuration: 1.0)
        
        User.singleton.positionComponent.xPosition = 100
        User.singleton.positionComponent.yPosition = 100
        User.singleton.spriteComponent.sprite.position.x = 100
        User.singleton.spriteComponent.sprite.position.y = 100
        
        if let nextScene {
            self.view?.presentScene(nextScene, transition: transition)
        }
    }
    
    private func getOutWinning () {
        let nextScene =  SKScene(fileNamed: "MainHallScene.sks")
        nextScene?.scaleMode = .aspectFill
        let transition = SKTransition.fade(withDuration: 1.0)
        
        // matar o inimigo mais perto.
        GameScene.GameSceneData.shared?.enemies.removeAll(where: { inimigo in
            inimigo.id == self.enemy.id
        })
        
        if let nextScene {
            self.view?.presentScene(nextScene, transition: transition)
        }
    }
    
    private func showItems () {
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
    
    internal func refreshItemState () {
        for i in 0 ..< User.singleton.inventoryComponent.itens.count {

            let node = self.childNode(withName: "itemRow\(i)") as! SKShapeNode
            if i == positionItemSelected {
                node.fillColor = .blue
            } else {
                node.fillColor = .gray
            }
        }
    }
    
     
}

