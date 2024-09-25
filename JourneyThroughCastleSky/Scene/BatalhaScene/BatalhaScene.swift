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
    
    var battleSystem = BattleSystem()
    
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
        case DODGE = 3
    }
    
    enum chooseState {
        case NONE
        case CHOOSE_BUTTON
        case CHOOSE_ITEM
        case SELECTED
    }
    
    override func didMove(to view: SKView) {
        setupNodes()
    }
    
    func setupNodes () {
        setupEnemy()
        setupTitleEnemy()
        setupButtonAttack()
        setupButtonSpare()
        setupButtonUseItem()
        setupMyLife()
        setupEnemyLife()
    }
    
    func config (enemy : Enemy) {
        battleSystem.enemy = enemy
        self.enemy = enemy
    }
    
    private func setupEnemy () {
        enemy.spriteComponent.sprite.position = PositionHelper.singleton.centralize(enemy.spriteComponent.sprite)
        enemy.spriteComponent.sprite.setScale(0.4)
        enemy.spriteComponent.sprite.position.y += 100
        addChild(enemy.spriteComponent.sprite)
    }
    
    // MARK: SETUP UI
    
    private func setupTitleEnemy () {
        let titleEnemy = SKLabelNode(text: "Inimigo")
        titleEnemy.position = PositionHelper.singleton.rightUpCorner(titleEnemy)
        titleEnemy.fontSize = 20
        addChild(titleEnemy)
    }
    
    private func setupButtonAttack () {
        buttonAttack = SKShapeNode(rect: CGRect(origin: PositionHelper.singleton.centralizeQuarterLeft(buttonAttack), size: CGSize(width: 100, height: 50)))
        buttonAttack.fillColor = .red
        buttonAttack.strokeColor = .white
        buttonAttack.position.x += 100
        addChild(buttonAttack)
    }
    
    private func setupButtonUseItem () {
        buttonUseItem = SKShapeNode(rect: CGRect(origin: PositionHelper.singleton.centralizeQuarterLeft(buttonUseItem), size: CGSize(width: 100, height: 50)))
        buttonUseItem.fillColor = .gray
        buttonUseItem.strokeColor = .white
        buttonUseItem.position.x += 250
        addChild(buttonUseItem)
    }
    
    private func setupButtonSpare () {
        buttonSpare = SKShapeNode(rect: CGRect(origin: PositionHelper.singleton.centralizeQuarterLeft(buttonSpare), size: CGSize(width: 100, height: 50)))
        buttonSpare.fillColor = .gray
        buttonSpare.strokeColor = .white
        buttonSpare.position.x += 400
        addChild(buttonSpare)
    }
    
    private func setupButtonDodge () {
        buttonDodge = SKShapeNode(rect: CGRect(origin: PositionHelper.singleton.centralizeQuarterLeft(buttonDodge), size: CGSize(width: 100, height: 50)))
        buttonDodge.fillColor = .gray
        buttonDodge.strokeColor = .white
        buttonDodge.position.x += 550
        addChild(buttonDodge)
    }
    
    private func setupEnemyLife () {
        enemyLifeLabel.text = "Life: \(enemy.healthComponent.health)"
        enemyLifeLabel.position = PositionHelper.singleton.rightUpCorner(enemyLifeLabel)
        enemyLifeLabel.position.y -= 30
        enemyLifeLabel.fontSize = 20

        addChild(enemyLifeLabel)
    }
    
    
    
    private func setupMyLife () {
        myLifeLabel.text = "Life: \(User.singleton.healthComponent.health)"
        myLifeLabel.position = PositionHelper.singleton.centralizeQuarterLeft(myLifeLabel)
        addChild(myLifeLabel)
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
        case 36: // Enter
            var result: ActionResult = ActionResult()
            switch buttonSelected {
                case .ATTACK:
                    result = attack()
                    gameChooseState = .SELECTED
                case .USE_ITEM:
                    showItems()
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
            useItem(User.singleton.inventoryComponent.itens[positionItemSelected])
            positionItemSelected = 0
            enemyTurn()
            
        default:
            return
        }
    }
    
    private func useItem(_ item : Item) {
        battleSystem.useItem(item)
        myLifeLabel.text = "Life: \(User.singleton.healthComponent.health)"
    }
    
    private func enemyTurn() {
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
        
        return actionResult
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

